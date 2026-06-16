#!/usr/bin/env node
/**
 * Generate examples/SwiftForgeDemo — a real, buildable iOS app that includes
 * every catalog component, proving the closed loop (agent → swiftforge →
 * compiling iOS app). Uses an Xcode 16+ file-system-synchronized group so we
 * don't have to register each .swift file in the pbxproj.
 *
 * Run: node scripts/make-demo.js   then build with xcodebuild (see README).
 */
import { readFileSync, writeFileSync, mkdirSync, rmSync } from "node:fs";
import { dirname, join } from "node:path";
import { fileURLToPath } from "node:url";

const ROOT = join(dirname(fileURLToPath(import.meta.url)), "..");
const comps = JSON.parse(readFileSync(join(ROOT, "catalog", "components.json"), "utf8"));

const APP = "SwiftForgeDemo";
const demoRoot = join(ROOT, "examples", APP);
const srcDir = join(demoRoot, APP);
const compDir = join(srcDir, "Components");
const projDir = join(demoRoot, `${APP}.xcodeproj`);

// fresh
rmSync(demoRoot, { recursive: true, force: true });
mkdirSync(compDir, { recursive: true });
mkdirSync(projDir, { recursive: true });

// 1) component files
for (const c of comps) {
  writeFileSync(join(compDir, `${c.id.replace(/[^a-zA-Z0-9_-]/g, "_")}.swift`), c.code.trimEnd() + "\n");
}

// 2) manifest
const sw = (s) => '"' + String(s).replace(/\\/g, "\\\\").replace(/"/g, '\\"').replace(/\n/g, " ") + '"';
const items = comps
  .map((c) => `        SwiftForgeItem(id: ${sw(c.id)}, title: ${sw(c.title)}, category: ${sw(c.category)}, minIOS: ${sw(c.minIOS)}, info: ${sw(c.description)})`)
  .join(",\n");
writeFileSync(
  join(srcDir, "Catalog.swift"),
  `import Foundation

struct SwiftForgeItem: Identifiable {
    let id: String
    let title: String
    let category: String
    let minIOS: String
    let info: String
}

enum SwiftForgeCatalog {
    static let items: [SwiftForgeItem] = [
${items}
    ]
    static let categories: [String] = items.reduce(into: [String]()) { acc, item in
        if !acc.contains(item.category) { acc.append(item.category) }
    }
}
`
);

// 3) app entry
writeFileSync(
  join(srcDir, "SwiftForgeDemoApp.swift"),
  `import SwiftUI

@main
struct SwiftForgeDemoApp: App {
    var body: some Scene {
        WindowGroup { ContentView() }
    }
}
`
);

// 4) ContentView — one live component + the full catalog list
writeFileSync(
  join(srcDir, "ContentView.swift"),
  `import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            DemoTab()
                .tabItem { Label("Demo", systemImage: "sparkles") }
            CatalogTab()
                .tabItem { Label("Catalog", systemImage: "square.grid.2x2") }
        }
    }
}

/// Live-renders real swiftforge components inside the running app.
private struct DemoTab: View {
    @State private var otp = ""
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 28) {
                    GroupBox("OTPInput — swiftforge") {
                        OTPInput(code: $otp).padding(.vertical, 8)
                    }
                    GroupBox("PaywallScreen — swiftforge") {
                        PaywallScreen(
                            title: "Unlock Pro",
                            benefits: ["Unlimited everything", "Priority support", "No ads, ever"],
                            plans: [
                                PaywallPlan(name: "Yearly", price: "$39.99", period: "year", badge: "Save 40%"),
                                PaywallPlan(name: "Monthly", price: "$5.99", period: "month")
                            ]
                        )
                        .frame(height: 540)
                    }
                }
                .padding()
            }
            .navigationTitle("SwiftForge")
        }
    }
}

/// Lists every component the agent can pull from swiftforge.
private struct CatalogTab: View {
    var body: some View {
        NavigationStack {
            List {
                ForEach(SwiftForgeCatalog.categories, id: \\.self) { cat in
                    Section(cat) {
                        ForEach(SwiftForgeCatalog.items.filter { $0.category == cat }) { item in
                            VStack(alignment: .leading, spacing: 4) {
                                HStack {
                                    Text(item.title).font(.headline)
                                    Spacer()
                                    Text("iOS " + item.minIOS).font(.caption).foregroundStyle(.secondary)
                                }
                                Text(item.info).font(.subheadline).foregroundStyle(.secondary)
                            }
                            .padding(.vertical, 2)
                        }
                    }
                }
            }
            .navigationTitle("Catalog · \\(SwiftForgeCatalog.items.count)")
        }
    }
}
`
);

// 5) pbxproj (objectVersion 77 + synchronized root group)
const ID = {
  project: "AA0000000000000000000001",
  mainGroup: "AA0000000000000000000002",
  prodGroup: "AA0000000000000000000003",
  srcGroup: "AA0000000000000000000004",
  target: "AA0000000000000000000005",
  appRef: "AA0000000000000000000006",
  srcPhase: "AA0000000000000000000007",
  frmPhase: "AA0000000000000000000008",
  resPhase: "AA0000000000000000000009",
  prjList: "AA000000000000000000000A",
  tgtList: "AA000000000000000000000B",
  prjDebug: "AA000000000000000000000C",
  prjRelease: "AA000000000000000000000D",
  tgtDebug: "AA000000000000000000000E",
  tgtRelease: "AA000000000000000000000F",
};

const targetSettings = `				ASSETCATALOG_COMPILER_GENERATE_ASSET_SYMBOLS = NO;
				CODE_SIGNING_ALLOWED = NO;
				CODE_SIGN_STYLE = Automatic;
				CURRENT_PROJECT_VERSION = 1;
				ENABLE_PREVIEWS = YES;
				GENERATE_INFOPLIST_FILE = YES;
				INFOPLIST_KEY_UIApplicationSceneManifest_Generation = YES;
				INFOPLIST_KEY_UIApplicationSupportsIndirectInputEvents = YES;
				INFOPLIST_KEY_UILaunchScreen_Generation = YES;
				INFOPLIST_KEY_UISupportedInterfaceOrientations = "UIInterfaceOrientationPortrait UIInterfaceOrientationLandscapeLeft UIInterfaceOrientationLandscapeRight";
				IPHONEOS_DEPLOYMENT_TARGET = 17.0;
				MARKETING_VERSION = 1.0;
				PRODUCT_BUNDLE_IDENTIFIER = com.swiftforge.demo;
				PRODUCT_NAME = "$(TARGET_NAME)";
				SWIFT_EMIT_LOC_STRINGS = YES;
				SWIFT_VERSION = 5.0;
				TARGETED_DEVICE_FAMILY = "1,2";`;

const projCommon = `				ALWAYS_SEARCH_USER_PATHS = NO;
				CLANG_ENABLE_MODULES = YES;
				CLANG_ENABLE_OBJC_ARC = YES;
				ENABLE_STRICT_OBJC_MSGSEND = YES;
				GCC_NO_COMMON_BLOCKS = YES;
				IPHONEOS_DEPLOYMENT_TARGET = 17.0;
				SDKROOT = iphoneos;
				SWIFT_VERSION = 5.0;`;

// Debug must be unoptimized (-Onone) or SwiftUI Previews refuse to run.
const projDebugSettings = `${projCommon}
				DEBUG_INFORMATION_FORMAT = dwarf;
				ENABLE_TESTABILITY = YES;
				GCC_DYNAMIC_NO_PIC = NO;
				GCC_OPTIMIZATION_LEVEL = 0;
				GCC_PREPROCESSOR_DEFINITIONS = (
					"DEBUG=1",
					"$(inherited)",
				);
				MTL_ENABLE_DEBUG_INFO = INCLUDE_SOURCE;
				ONLY_ACTIVE_ARCH = YES;
				SWIFT_ACTIVE_COMPILATION_CONDITIONS = "DEBUG $(inherited)";
				SWIFT_OPTIMIZATION_LEVEL = "-Onone";`;

const projReleaseSettings = `${projCommon}
				DEBUG_INFORMATION_FORMAT = "dwarf-with-dsym";
				ENABLE_NS_ASSERTIONS = NO;
				MTL_ENABLE_DEBUG_INFO = NO;
				SWIFT_COMPILATION_MODE = wholemodule;
				SWIFT_OPTIMIZATION_LEVEL = "-O";`;

const pbx = `// !$*UTF8*$!
{
	archiveVersion = 1;
	classes = {
	};
	objectVersion = 77;
	objects = {

/* Begin PBXFileReference section */
		${ID.appRef} /* ${APP}.app */ = {isa = PBXFileReference; explicitFileType = wrapper.application; includeInIndex = 0; path = ${APP}.app; sourceTree = BUILT_PRODUCTS_DIR; };
/* End PBXFileReference section */

/* Begin PBXFileSystemSynchronizedRootGroup section */
		${ID.srcGroup} /* ${APP} */ = {
			isa = PBXFileSystemSynchronizedRootGroup;
			path = ${APP};
			sourceTree = "<group>";
		};
/* End PBXFileSystemSynchronizedRootGroup section */

/* Begin PBXFrameworksBuildPhase section */
		${ID.frmPhase} /* Frameworks */ = {
			isa = PBXFrameworksBuildPhase;
			buildActionMask = 2147483647;
			files = (
			);
			runOnlyForDeploymentPostprocessing = 0;
		};
/* End PBXFrameworksBuildPhase section */

/* Begin PBXGroup section */
		${ID.mainGroup} = {
			isa = PBXGroup;
			children = (
				${ID.srcGroup} /* ${APP} */,
				${ID.prodGroup} /* Products */,
			);
			sourceTree = "<group>";
		};
		${ID.prodGroup} /* Products */ = {
			isa = PBXGroup;
			children = (
				${ID.appRef} /* ${APP}.app */,
			);
			name = Products;
			sourceTree = "<group>";
		};
/* End PBXGroup section */

/* Begin PBXNativeTarget section */
		${ID.target} /* ${APP} */ = {
			isa = PBXNativeTarget;
			buildConfigurationList = ${ID.tgtList} /* Build configuration list for PBXNativeTarget "${APP}" */;
			buildPhases = (
				${ID.srcPhase} /* Sources */,
				${ID.frmPhase} /* Frameworks */,
				${ID.resPhase} /* Resources */,
			);
			buildRules = (
			);
			dependencies = (
			);
			fileSystemSynchronizedGroups = (
				${ID.srcGroup} /* ${APP} */,
			);
			name = ${APP};
			productName = ${APP};
			productReference = ${ID.appRef} /* ${APP}.app */;
			productType = "com.apple.product-type.application";
		};
/* End PBXNativeTarget section */

/* Begin PBXProject section */
		${ID.project} /* Project object */ = {
			isa = PBXProject;
			attributes = {
				BuildIndependentTargetsInParallel = 1;
				LastSwiftUpdateCheck = 2650;
				LastUpgradeCheck = 2650;
				TargetAttributes = {
					${ID.target} = {
						CreatedOnToolsVersion = 26.5;
					};
				};
			};
			buildConfigurationList = ${ID.prjList} /* Build configuration list for PBXProject "${APP}" */;
			compatibilityVersion = "Xcode 15.0";
			developmentRegion = en;
			hasScannedForEncodings = 0;
			knownRegions = (
				en,
				Base,
			);
			mainGroup = ${ID.mainGroup};
			minimizedProjectReferenceProxies = 1;
			preferredProjectObjectVersion = 77;
			productRefGroup = ${ID.prodGroup} /* Products */;
			projectDirPath = "";
			projectRoot = "";
			targets = (
				${ID.target} /* ${APP} */,
			);
		};
/* End PBXProject section */

/* Begin PBXResourcesBuildPhase section */
		${ID.resPhase} /* Resources */ = {
			isa = PBXResourcesBuildPhase;
			buildActionMask = 2147483647;
			files = (
			);
			runOnlyForDeploymentPostprocessing = 0;
		};
/* End PBXResourcesBuildPhase section */

/* Begin PBXSourcesBuildPhase section */
		${ID.srcPhase} /* Sources */ = {
			isa = PBXSourcesBuildPhase;
			buildActionMask = 2147483647;
			files = (
			);
			runOnlyForDeploymentPostprocessing = 0;
		};
/* End PBXSourcesBuildPhase section */

/* Begin XCBuildConfiguration section */
		${ID.prjDebug} /* Debug */ = {
			isa = XCBuildConfiguration;
			buildSettings = {
${projDebugSettings}
			};
			name = Debug;
		};
		${ID.prjRelease} /* Release */ = {
			isa = XCBuildConfiguration;
			buildSettings = {
${projReleaseSettings}
			};
			name = Release;
		};
		${ID.tgtDebug} /* Debug */ = {
			isa = XCBuildConfiguration;
			buildSettings = {
${targetSettings}
			};
			name = Debug;
		};
		${ID.tgtRelease} /* Release */ = {
			isa = XCBuildConfiguration;
			buildSettings = {
${targetSettings}
			};
			name = Release;
		};
/* End XCBuildConfiguration section */

/* Begin XCConfigurationList section */
		${ID.prjList} /* Build configuration list for PBXProject "${APP}" */ = {
			isa = XCConfigurationList;
			buildConfigurations = (
				${ID.prjDebug} /* Debug */,
				${ID.prjRelease} /* Release */,
			);
			defaultConfigurationIsVisible = 0;
			defaultConfigurationName = Release;
		};
		${ID.tgtList} /* Build configuration list for PBXNativeTarget "${APP}" */ = {
			isa = XCConfigurationList;
			buildConfigurations = (
				${ID.tgtDebug} /* Debug */,
				${ID.tgtRelease} /* Release */,
			);
			defaultConfigurationIsVisible = 0;
			defaultConfigurationName = Release;
		};
/* End XCConfigurationList section */
	};
	rootObject = ${ID.project} /* Project object */;
}
`;

writeFileSync(join(projDir, "project.pbxproj"), pbx);

// 6) shared scheme — Run/Test/Analyze use Debug so SwiftUI Previews work (-Onone)
const ref = `<BuildableReference BuildableIdentifier = "primary" BlueprintIdentifier = "${ID.target}" BuildableName = "${APP}.app" BlueprintName = "${APP}" ReferencedContainer = "container:${APP}.xcodeproj"></BuildableReference>`;
const scheme = `<?xml version="1.0" encoding="UTF-8"?>
<Scheme LastUpgradeVersion = "2650" version = "1.7">
   <BuildAction parallelizeBuildables = "YES" buildImplicitDependencies = "YES">
      <BuildActionEntries>
         <BuildActionEntry buildForTesting = "YES" buildForRunning = "YES" buildForProfiling = "YES" buildForArchiving = "YES" buildForAnalyzing = "YES">
            ${ref}
         </BuildActionEntry>
      </BuildActionEntries>
   </BuildAction>
   <TestAction buildConfiguration = "Debug" selectedDebuggerIdentifier = "Xcode.DebuggerFoundation.Debugger.LLDB" selectedLauncherIdentifier = "Xcode.DebuggerFoundation.Launcher.LLDB" shouldUseLaunchSchemeArgsEnv = "YES"></TestAction>
   <LaunchAction buildConfiguration = "Debug" selectedDebuggerIdentifier = "Xcode.DebuggerFoundation.Debugger.LLDB" selectedLauncherIdentifier = "Xcode.DebuggerFoundation.Launcher.LLDB" launchStyle = "0" useCustomWorkingDirectory = "NO" ignoresPersistentStateOnLaunch = "NO" debugDocumentVersioning = "YES" debugServiceExtension = "internal" allowLocationSimulation = "YES">
      <BuildableProductRunnable runnableDebuggingMode = "0">
         ${ref}
      </BuildableProductRunnable>
   </LaunchAction>
   <ProfileAction buildConfiguration = "Release" shouldUseLaunchSchemeArgsEnv = "YES" savedToolIdentifier = "" useCustomWorkingDirectory = "NO" debugDocumentVersioning = "YES">
      <BuildableProductRunnable runnableDebuggingMode = "0">
         ${ref}
      </BuildableProductRunnable>
   </ProfileAction>
   <AnalyzeAction buildConfiguration = "Debug"></AnalyzeAction>
   <ArchiveAction buildConfiguration = "Release" revealArchiveInOrganizer = "YES"></ArchiveAction>
</Scheme>
`;
const schemeDir = join(projDir, "xcshareddata", "xcschemes");
mkdirSync(schemeDir, { recursive: true });
writeFileSync(join(schemeDir, `${APP}.xcscheme`), scheme);

console.log(`Generated ${APP} with ${comps.length} component files at examples/${APP}/`);
