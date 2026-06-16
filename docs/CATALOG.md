# SwiftForge Catalog

> Auto-generated from `catalog/components.json`. **96 components across 14 categories.**
> Your AI agent fetches these on demand via MCP — see [README](../README.md) / [USAGE](USAGE.md).

## Categories
- [Buttons & Controls](#buttons-controls) — 9
- [Cards & Containers](#cards-containers) — 9
- [Navigation & Bars](#navigation-bars) — 6
- [Lists & Scroll](#lists-scroll) — 6
- [Forms & Inputs](#forms-inputs) — 9
- [Effects & Liquid Glass](#effects-liquid-glass) — 9
- [Feedback & Overlays](#feedback-overlays) — 9
- [Onboarding & Hero](#onboarding-hero) — 6
- [Charts](#charts) — 6
- [Lists & Grids](#lists-grids) — 3
- [Media](#media) — 6
- [Auth & Account](#auth-account) — 6
- [Animations](#animations) — 6
- [Layout & Scaffolding](#layout-scaffolding) — 6

## Buttons & Controls

| Component | min iOS | Deps | What it is |
| --- | --- | --- | --- |
| **Primary & Secondary Button Styles** <br>`primary-secondary-button-style-set` | 17.0 | — | A cohesive primary/secondary button style set with press-scale feedback, tinted fills, and a polished disabled state. Drop-in ButtonStyle types you apply with .buttonStyle(). |
| **Liquid Glass Button (iOS 26)** <br>`liquid-glass-button-ios26` | 26.0 | SF Symbols | An iOS 26 Liquid Glass action button using .buttonStyle(.glass) / .glassProminent inside a GlassEffectContainer, with a graceful .ultraThinMaterial fallback for iOS 17-25. |
| **Animated Segmented Control** <br>`animated-segmented-control` | 17.0 | — | A custom segmented control with a sliding, matched-geometry selection pill, haptic feedback, Reduce Motion support, and full Dynamic Type support. Generic over any Hashable option set. |
| **Async Loading Button** <br>`async-loading-button` | 17.0 | SF Symbols | A primary action button that runs an async task, shows an inline spinner, and disables itself while in flight to prevent double-taps. Label content stays sized so the button doesn't jump. |
| **Floating Action Button (FAB)** <br>`floating-action-button` | 17.0 | SF Symbols | A circular Material Design-style floating action button with a soft shadow, press-scale feedback, and an optional expanding label pill. Designed to sit in a bottom-trailing overlay over scrolling content. |
| **Horizontal Chip Filter Row** <br>`horizontal-chip-filter-row` | 17.0 | SF Symbols | A horizontally scrolling row of selectable filter chips with multi-select, animated fill/stroke transitions, optional SF Symbol icons, and haptic feedback. Backed by a simple Identifiable filter model. |
| **Context Menu Action Button** <br>`context-menu-action-button` | 17.0 | SF Symbols | A tappable label that reveals a native long-press context menu of actions, including a grouped destructive section. Built on SwiftUI's .contextMenu with Button(role:) for correct system styling. |
| **Circular Icon Button with Badge** <br>`circular-icon-badge-button` | 17.0 | SF Symbols | A circular icon button (notifications/cart style) with a material or tinted fill, press-scale feedback, and an optional numeric count badge that clamps to 99+ and hides at zero. Great for toolbars and headers. |
| **Social Share Buttons Row** <br>`social-share-buttons-row` | 17.0 | SF Symbols | A row of branded circular share buttons (Messages, Mail, Copy Link, more) with per-platform tint colors, press feedback, and a trailing native ShareLink for the system share sheet. Wraps gracefully and adapts to Dynamic Type. |

## Cards & Containers

| Component | min iOS | Deps | What it is |
| --- | --- | --- | --- |
| **Liquid Glass Feature Card** <br>`liquid-glass-feature-card` | 26.0 | SF Symbols | A translucent iOS 26 Liquid Glass card with a tinted glass icon badge and a glass action button, wrapped in a GlassEffectContainer so the elements blend correctly. Degrades gracefully to ultraThinMaterial on earlier iOS. |
| **Stat / Metric Card** <br>`stat-metric-card` | 17.0 | SF Symbols | A compact KPI card showing a value, label, and a colored delta chip with an up/down trend arrow. Auto-derives trend direction and color from the change value, and exposes a clean accessibility summary. |
| **Expandable Disclosure Card** <br>`expandable-disclosure-card` | 17.0 | SF Symbols | A tappable card that smoothly expands to reveal detail content, with a rotating chevron and spring animation. The whole header is an accessible button exposing an expanded/collapsed state to VoiceOver. |
| **Featured Pricing Tier Card** <br>`featured-pricing-tier-card` | 17.0 | SF Symbols | A pricing plan card with a featured variant that lifts with a tinted border, a 'Most Popular' badge, a gradient-tinted header, and a checkmarked feature list. The CTA and styling adapt automatically when marked featured. |
| **Profile Header Card** <br>`profile-header-card` | 17.0 | SF Symbols | A user profile header card with a gradient cover banner, an overlapping avatar (AsyncImage with monogram fallback), name with optional verified badge, handle, bio, an inline stats row, and a primary follow/edit action. |
| **Product Showcase Card** <br>`product-showcase-card` | 17.0 | SF Symbols | An e-commerce product card with an AsyncImage thumbnail, a favorite toggle overlay, optional sale badge, title, rating row, strike-through compare-at price, and a circular add-to-cart button with a tap-confirmation animation. |
| **Chrono Timeline Event Row** <br>`chrono-timeline-event-row` | 17.0 | SF Symbols | A single vertical-timeline entry: a colored gradient node on a connecting rail with an SF Symbol badge, plus a card showing a title, timestamp, and optional detail. Stack several to build a full activity/order-tracking timeline; isFirst/isLast control where the rail draws and isPending renders a hollow ring node. |
| **Pulse KPI Trend Card** <br>`pulse-kpi-trend-card` | 17.0 | Swift Charts, SF Symbols | A hero KPI tile combining a large headline value, a signed delta chip, and a comparison-period caption above a full-width gradient area mini-chart that fills the bottom of the card. Trend color and arrow derive automatically from the change sign; the area scale is padded so flat series still render. |
| **Spotlight Testimonial Card** <br>`spotlight-testimonial-card` | 17.0 | SF Symbols | A social-proof testimonial/quote card with a large decorative quotation glyph, the quote body, an optional 5-star rating row, and an author row with an AsyncImage avatar (monogram fallback), name, and role. Fully parameterized and dark-mode ready. |

## Navigation & Bars

| Component | min iOS | Deps | What it is |
| --- | --- | --- | --- |
| **Floating Pill Tab Bar** <br>`floating-pill-tab-bar` | 17.0 | SF Symbols | A custom floating tab bar that hovers above content as a rounded capsule, with an animated selection pill, SF Symbol icons, and a matchedGeometryEffect highlight. Fully data-driven, dark-mode friendly, and Reduce Motion aware. |
| **Searchable NavigationStack List** <br>`searchable-nav-stack-list` | 17.0 | SF Symbols | A NavigationStack + searchable list pattern with live filtering, type-safe value-based navigation via navigationDestination, swipe-to-favorite, and the system empty-search / empty-data states shown as a centered overlay. |
| **Glass Bottom Action Bar** <br>`glass-bottom-action-bar` | 26.0 | SF Symbols | A glassy bottom action bar using iOS 26 Liquid Glass: a primary capsule CTA plus secondary icon buttons grouped in a GlassEffectContainer for fluid merging, with a graceful material fallback on earlier iOS. |
| **Custom Detent Bottom Sheet** <br>`custom-detent-bottom-sheet` | 17.0 | SF Symbols | A reusable bottom sheet built on presentationDetents with a custom fractional detent, a grabber, programmatic detent selection, and a translucent background. Tracks the active detent so the host can react to expansion. |
| **NavigationSplitView Sidebar Layout** <br>`split-view-sidebar-layout` | 17.0 | SF Symbols | A two-column adaptive layout using NavigationSplitView with a sectioned, value-selectable sidebar, a detail NavigationStack for in-pane pushes, and a balanced column-visibility default. Collapses to a single push stack on iPhone and expands to sidebar + detail on iPad/Mac automatically. |
| **Swipeable Paged TabView with Indicators** <br>`paged-tab-view-indicators` | 17.0 | SF Symbols | A horizontally swipeable paged carousel using TabView(.page) with a custom animated dot indicator, tappable dots, and a smooth scaling/opacity transition between pages. Reduce Motion aware and fully data-driven. |

## Lists & Scroll

| Component | min iOS | Deps | What it is |
| --- | --- | --- | --- |
| **Pull-to-Refresh Async List** <br>`pull-to-refresh-async-list` | 17.0 | SF Symbols | A List with native pull-to-refresh wired to an async data source. Shows a loading state on first appearance, an empty state when the feed is empty, and surfaces errors with a retry affordance. |
| **Swipe-Actions Row** <br>`swipe-actions-row` | 17.0 | SF Symbols | A reusable List row with leading and trailing swipe actions (toggle read/unread, pin, delete) using role-based buttons, tints, and full-swipe support. |
| **Parallax Scroll Header** <br>`parallax-scroll-header` | 17.0 | SF Symbols | A stretchy parallax hero header plus list rows that fade, scale, and blur as they scroll toward the edges, all driven by scrollTransition. |
| **Expandable Collapsible Section List** <br>`expandable-section-collapsible-list` | 17.0 | SF Symbols | A grouped list whose section headers act as tap targets to expand or collapse their rows, with an animated chevron, a count badge, and a leading icon. Generic over any Identifiable item and any row content, with per-section expand state tracked in a Set. |
| **Pinned Sticky Header Scroll List** <br>`pinned-sticky-header-scroll-list` | 17.0 | — | A ScrollView + LazyVStack with pinnedViews section headers that stick to the top as you scroll, using a translucent .bar background. Generic over any Identifiable item with a custom row builder, drawing inset dividers between rows. |
| **Grouped Inset Settings List With Footers** <br>`grouped-inset-settings-footer-list` | 17.0 | SF Symbols | A Settings-style inset grouped list with section headers and explanatory footers, and rounded tinted icon tiles. Rows support three accessory styles: a bound Toggle, a trailing value label, or a disclosure chevron, driven by an enum. |

## Forms & Inputs

| Component | min iOS | Deps | What it is |
| --- | --- | --- | --- |
| **Validated Text Field** <br>`validated-text-field` | 17.0 | SF Symbols | A reusable text field with inline validation, focus-aware styling, an error message that animates in, and a clear button. Validation defers until first blur or submit, then runs live as the user types. |
| **OTP / Pin Code Input** <br>`otp-pin-input` | 17.0 | — | A segmented one-time-code input with per-digit boxes, an animated focus ring, paste support, and auto-submit when full. Backed by a single hidden field so the system OTP autofill and backspace work correctly. |
| **Modern Form Settings Screen** <br>`form-settings-screen` | 17.0 | SF Symbols | A grouped settings screen pattern using Form with a profile header, toggles, a picker, a stepper, a navigation row, and a destructive action — driven by an @Observable model. |
| **Clearable Search Bar Field** <br>`clearable-search-bar-field` | 17.0 | SF Symbols | A polished search bar with a leading magnifying-glass icon, an inline clear button that appears while typing, and managed focus with an animated Cancel button. Drop-in replacement for the system .searchable when you need full styling control. |
| **Token / Tag Input Field** <br>`token-tag-input-field` | 17.0 | SF Symbols | A wrapping tag editor: type a label and press return (or comma) to commit a token, tap the x on any chip to remove it, and tap empty space to focus. Duplicates are ignored and tokens wrap into multiple rows via a Layout-based flow. |
| **Interactive Star Rating Input** <br>`interactive-star-rating-input` | 17.0 | SF Symbols | A tappable and draggable star rating control. Tap a star to set the rating, or drag across the row to scrub; supports configurable star count, an optional clear-on-retap, springy fill animation, and full VoiceOver adjustable-action support. |
| **Labeled Stepper Quantity Field** <br>`labeled-stepper-quantity-field` | 17.0 | SF Symbols | A quantity control pairing a leading label and SF Symbol with a pill stepper of minus/plus buttons and a tappable count that opens an inline keypad-style text field. Clamps to a configurable range with a step, disables buttons at the bounds, and animates the count with a rolling numeric transition. |
| **Inline Expanding Date Picker Row** <br>`inline-expanding-date-picker-row` | 17.0 | SF Symbols | A form row that shows a label, an SF Symbol, and the formatted selected date; tapping it expands a graphical DatePicker inline with a smooth height animation and a chevron that rotates. Optionally includes a time wheel and collapses automatically after a date is chosen. |
| **Multiline Text Editor with Character Counter** <br>`multiline-text-editor-counter` | 17.0 | SF Symbols | A bordered, growing TextEditor with a floating placeholder, a live character counter that turns warning then error as the limit nears, hard enforcement of a max length, and a focus-aware accent border. Includes an optional title and helper text. |

## Effects & Liquid Glass

| Component | min iOS | Deps | What it is |
| --- | --- | --- | --- |
| **Morphing Glass Capsule Bar** <br>`morphing-glass-toolbar` | 26.0 | SF Symbols | A row of Liquid Glass action chips that fluidly morph and merge into one another using GlassEffectContainer and glassEffectID. Tapping the lead chip expands the set with a springy glass-blend animation. |
| **Shimmer Skeleton Loader** <br>`shimmer-skeleton-modifier` | 17.0 | — | A reusable .shimmering() view modifier plus a SkeletonView placeholder. Drives a diagonal highlight sweep across redacted content for elegant loading states. Respects Reduce Motion. |
| **Animated Mesh Gradient Background** <br>`animated-mesh-gradient-background` | 17.0 | — | A living MeshGradient background whose control points drift continuously with a TimelineView, producing a smooth aurora-like motion. Falls back to an animated LinearGradient with a drifting hue rotation on iOS 17. |
| **Liquid Glass Tab Bar (iOS 26)** <br>`liquid-glass-tab-bar-ios26` | 26.0 | SF Symbols | A floating custom tab bar rendered as a single Liquid Glass capsule, with an interactive tinted glass selection pill that morphs between tabs using glassEffectID inside a GlassEffectContainer. Falls back to ultraThinMaterial on iOS 17-25. |
| **Liquid Glass Search Pill (iOS 26)** <br>`liquid-glass-search-pill-ios26` | 26.0 | SF Symbols | A floating search field rendered as an interactive Liquid Glass capsule with a leading magnifier, focus-driven tint, and a morphing clear button that materializes in via glassEffectID. Degrades to ultraThinMaterial on iOS 17-25. |
| **Liquid Glass Popover Card (iOS 26)** <br>`liquid-glass-popover-card-ios26` | 26.0 | SF Symbols | A floating Liquid Glass popover/sheet card with a glass close chip, headline, body, and a prominent glass confirm button, presented over a dimmed scrim with a spring scale-in. Falls back to ultraThinMaterial on iOS 17-25. |
| **Liquid Glass Segmented Control (iOS 26)** <br>`liquid-glass-segmented-control-ios26` | 26.0 | SF Symbols | An iOS 26 Liquid Glass segmented picker rendered as a single glass capsule track with an interactive tinted glass selection pill that fluidly morphs between segments using glassEffectID inside a GlassEffectContainer. Generic over any Hashable & Identifiable segment, with a graceful ultraThinMaterial fallback on iOS 17-25. |
| **Liquid Glass Navigation Top Bar (iOS 26)** <br>`liquid-glass-nav-top-bar-ios26` | 26.0 | SF Symbols | A custom floating top navigation bar for iOS 26 built from separate Liquid Glass capsules — a leading back chip, a centered title pill, and trailing icon action chips — grouped in a GlassEffectContainer so they blend at the edges. Designed to float over scrolling content with a graceful ultraThinMaterial fallback on iOS 17-25. |
| **Liquid Glass FAB Speed Dial (iOS 26)** <br>`liquid-glass-fab-speed-dial-ios26` | 26.0 | SF Symbols | An iOS 26 Liquid Glass floating action button that morphs into a vertical speed-dial of tinted glass mini-action chips. The main button and each child share a GlassEffectContainer and glassEffectID so the menu fluidly grows out of the FAB, with a rotating plus icon and an ultraThinMaterial fallback on iOS 17-25. |

## Feedback & Overlays

| Component | min iOS | Deps | What it is |
| --- | --- | --- | --- |
| **Toast / Snackbar with Auto-Dismiss** <br>`toast-snackbar-auto-dismiss` | 17.0 | SF Symbols | A lightweight, theme-able toast that slides in from the top, auto-dismisses after a configurable delay, and is presented via a reusable .toast(...) view modifier bound to an optional item. |
| **Blocking Loading Overlay** <br>`loading-overlay-material` | 17.0 | — | A full-screen blocking loading overlay with a dimmed material scrim, a progress indicator, and an optional message. Presented through a reusable .loadingOverlay(isPresented:message:) modifier that disables interaction underneath. |
| **Animated Circular Progress Ring** <br>`circular-progress-ring` | 17.0 | — | A circular progress ring that animates its trim and an optional center percentage label as progress changes. Supports a gradient stroke, rounded line caps, and a customizable track — drop-in for upload/download or goal completion UI. |
| **Notification Count Badge** <br>`notification-count-badge` | 17.0 | SF Symbols | A reusable count badge that overlays any content with a capsule-shaped counter, clamps large values to a "99+" style cap, and animates pops as the count changes. Supports a dot-only mode for unread indicators. |
| **Empty State Placeholder** <br>`empty-state-placeholder-view` | 17.0 | SF Symbols | A polished, centered empty-state view with an SF Symbol in a soft tinted circle, a title, a supporting message, and an optional call-to-action button. Dark-mode and Dynamic Type friendly with a graceful gentle entrance. |
| **Multi-Step Linear Progress** <br>`multi-step-linear-progress` | 17.0 | SF Symbols | A horizontal multi-step progress indicator with numbered/checkmark nodes connected by a track that animates its fill as the user advances. Marks completed, current, and upcoming steps distinctly with optional captions. |
| **Inline Banner Alert** <br>`inline-banner-alert` | 17.0 | SF Symbols | An inline, in-flow banner alert with four semantic styles (info, success, warning, error), each with its own SF Symbol, tint, and tinted background. Supports an optional dismiss button and a trailing action button, and adapts to dark mode and Dynamic Type. |
| **Status Indicator Pill** <br>`status-indicator-pill` | 17.0 | SF Symbols | A compact capsule status chip with a leading status dot, semantic color, and optional SF Symbol. Includes a pulsing live mode for active/online states and presets for online, away, busy, offline, success, pending, and error. Tinted fill adapts to dark mode. |
| **Full-Screen Error + Retry View** <br>`full-screen-error-retry-view` | 17.0 | SF Symbols | A centered full-screen error state with an SF Symbol in a soft tinted circle, a title, a descriptive message, a primary Retry button showing an inline spinner while retrying, and an optional secondary action. Ideal for failed network loads and async task failures. |

## Onboarding & Hero

| Component | min iOS | Deps | What it is |
| --- | --- | --- | --- |
| **Onboarding Pager with Paging Dots** <br>`onboarding-pager-dots` | 17.0 | SF Symbols | A multi-page onboarding flow with swipeable pages, animated capsule paging dots, and a Continue/Get Started button that advances pages and finishes on the last one. |
| **Feature Highlight Row List** <br>`feature-highlight-row-list` | 17.0 | SF Symbols | A vertically stacked list of feature highlights, each with an SF Symbol in a tinted rounded badge, a title, and a description. Ideal for 'What's New' or onboarding value props. |
| **Paywall Screen Layout** <br>`paywall-screen-layout` | 17.0 | SF Symbols | A tasteful subscription paywall with a hero header, benefit list, selectable pricing plans, a prominent subscribe button, and restore/terms footer links. |
| **Welcome Hero Splash Screen** <br>`welcome-hero-splash-screen` | 17.0 | SF Symbols | A branded first-launch hero splash with an animated gradient backdrop, a glowing logo mark that scales and fades in, an app title with tagline, and a prominent Get Started call-to-action plus a subtle secondary link. |
| **Permission Walkthrough Step View** <br>`permission-walkthrough-step-view` | 17.0 | SF Symbols | A single full-screen permission-request step for a guided walkthrough: a tinted icon, a benefit-framed title and reason, a step progress indicator, and Allow / Not Now actions that report the user's choice. |
| **What's New Release Notes Sheet** <br>`whats-new-release-notes-sheet` | 17.0 | SF Symbols | A versioned 'What's New' release-notes sheet with an app icon header, version label, a scrollable list of feature changes each with a tinted SF Symbol, and a pinned Continue button to dismiss. |

## Charts

| Component | min iOS | Deps | What it is |
| --- | --- | --- | --- |
| **Gradient Area Line Chart Card** <br>`gradient-area-line-chart-card` | 17.0 | Swift Charts | A polished card wrapping a Swift Charts line chart with a soft gradient area fill, smooth interpolation, and a header showing the latest value plus trend delta. |
| **Donut Ring Chart With Center Label** <br>`donut-ring-chart-center-label` | 17.0 | Swift Charts | A Swift Charts donut chart (SectorMark with inner radius) showing categorical proportions, with a center overlay for the total and a compact color-coded legend below. |
| **Compact Sparkline Trend Row** <br>`compact-sparkline-trend-row` | 17.0 | Swift Charts | A dense list row pairing a label and current value with an inline Swift Charts sparkline and a colored trend pill, ideal for watchlists, KPI lists, or metric dashboards. |
| **Grouped Bar Chart Card** <br>`grouped-bar-chart-card` | 17.0 | Swift Charts | A multi-series grouped bar chart comparing two metrics across categories, with a legend, a configurable (currency-aware) axis format, and rounded bar marks. Great for revenue vs. target or this-year vs. last-year comparisons. |
| **Multi-Line Trend Chart Card** <br>`multi-line-trend-chart-card` | 17.0 | Swift Charts | A multi-line time-series chart with a legend, distinct colors per series, point marks on each vertex, and an interpolated curve. Ideal for comparing several metrics or cohorts over time. |
| **Activity Rings Progress Gauge** <br>`activity-rings-progress-gauge` | 17.0 | Swift Charts | An activity-rings style progress gauge that stacks multiple concentric rings, each animating to its goal percentage with rounded caps and a configurable center label. Built with Swift Charts sector marks for crisp, scalable rendering. |

## Lists & Grids

| Component | min iOS | Deps | What it is |
| --- | --- | --- | --- |
| **Adaptive Photo Grid** <br>`adaptive-photo-grid` | 17.0 | SF Symbols | A responsive photo grid built on LazyVGrid with adaptive columns that reflow to fit any width. Each tile is a square, aspect-filled, rounded thumbnail with a smooth tap-to-select highlight and an overlaid checkmark. |
| **Reorderable Move List** <br>`reorderable-move-list` | 17.0 | SF Symbols | An editable List whose rows can be dragged into a new order with onMove and removed with onDelete. Includes a built-in EditButton, a drag-handle affordance, and persistent ordering in local @State. |
| **Infinite Scroll Paging List** <br>`infinite-scroll-paging-list` | 17.0 | SF Symbols | An infinite-scroll List that loads the next page when the last row appears, with an inline progress footer, an end-of-list sentinel, and a simulated async data source ready to swap for a real API. |

## Media

| Component | min iOS | Deps | What it is |
| --- | --- | --- | --- |
| **Async Remote Image** <br>`async-remote-image` | 17.0 | SF Symbols | A polished AsyncImage wrapper with a shimmering placeholder while loading, a smooth fade-in on success, and a tappable retry state on failure. Crops to a rounded rectangle with a configurable aspect ratio. |
| **Initials Avatar View** <br>`initials-avatar-view` | 17.0 | SF Symbols | A circular avatar that shows a remote/local image when available and otherwise falls back to colored initials. The fallback background color is derived deterministically from the name, so each person gets a stable, distinct color. Optional status badge. |
| **Snapping Image Carousel** <br>`snapping-image-carousel` | 17.0 | SF Symbols | A horizontally paging image carousel with native scroll snapping, a soft scale/parallax effect on the active page, and an animated page-dot indicator. Each slide loads asynchronously with a placeholder. |
| **Pinch-to-Zoom Image Detail View** <br>`pinch-zoom-image-detail-view` | 17.0 | SF Symbols | A full-screen photo viewer with pinch-to-zoom (MagnifyGesture), drag-to-pan when zoomed, and double-tap to toggle between fit and 2x. Zoom is clamped to a sensible range and springs back to identity when released below 1x. Pan is bounded so the image never drifts off-screen, and a Reset control restores the fit state. |
| **Play Badge Media Thumbnail** <br>`play-badge-media-thumbnail` | 17.0 | SF Symbols | A tappable video/media grid thumbnail with a frosted circular play badge, an optional duration pill, and a press-down scale animation. Crops the artwork to a fixed-aspect rounded rectangle with a subtle bottom gradient so the duration text stays legible over bright frames. Designed to tile cleanly in a LazyVGrid. |
| **Cover Photo Avatar Header** <br>`cover-photo-avatar-header` | 17.0 | SF Symbols | A profile header with a full-bleed cover photo, a gradient scrim for legibility, and a circular avatar that overlaps the cover edge with a ring border. Shows name, subtitle, and an optional trailing action button. The avatar overlap is achieved with negative padding so the layout flows naturally above following content. |

## Auth & Account

| Component | min iOS | Deps | What it is |
| --- | --- | --- | --- |
| **Sign-In Screen Layout** <br>`email-password-social-signin-screen` | 17.0 | SF Symbols | A polished sign-in screen with email and password fields, a forgot-password link, a primary sign-in button, an 'or' divider, and social sign-in buttons (Apple, Google). Driven by an @Observable model with focus handling and a loading state. |
| **Sign in with Apple Button Wrapper** <br>`sign-in-with-apple-button-wrapper` | 17.0 | AuthenticationServices, SF Symbols | A styling wrapper around the native SignInWithAppleButton that handles light/dark adaptation, corner radius, fixed height, and the authorization request/result, exposing simple onSuccess/onError callbacks with the resolved ASAuthorizationAppleIDCredential. |
| **Permission Primer Sheet** <br>`permission-primer-sheet` | 17.0 | SF Symbols | A pre-permission priming sheet shown before a system prompt (notifications, location, camera, etc.). Explains the value with an icon, benefit rows, and Allow / Not Now actions so users arrive at the OS dialog primed to accept. Presented via a reusable .permissionPrimer(...) modifier. |
| **Editable Profile Account Form** <br>`editable-profile-account-form` | 17.0 | SF Symbols | An editable account profile form with a tappable avatar header, inline text fields for name and email, a bio editor, and a sticky save button that activates only when fields change. Tracks a dirty state so users get clear feedback that edits are pending, and validates a non-empty name and a well-formed email before allowing save. |
| **Social Login Buttons Stack** <br>`social-login-buttons-row` | 17.0 | SF Symbols | A vertical stack of full-width social sign-in buttons for Apple, Google, and email, each with the correct brand styling: a solid black Sign in with Apple button, a bordered white Google button, and a tinted email button. Includes an 'or' divider and per-provider tap callbacks. Each button shows a real pressed-state (scale + opacity) and is accessibility-labeled. |
| **Delete Account Confirmation Flow** <br>`delete-account-confirm-flow` | 17.0 | SF Symbols | A destructive delete-account flow with layered safety: a warning card listing what gets erased, a required type-to-confirm field (user must type DELETE), and a final confirmationDialog before the irreversible action fires. The destructive button stays disabled until the confirmation phrase matches, and the action runs through an async loading state. |

## Animations

| Component | min iOS | Deps | What it is |
| --- | --- | --- | --- |
| **Heart Like Burst Animation** <br>`heart-like-burst-animation` | 17.0 | SF Symbols | A tappable like button that pops the heart with a spring and emits a radiating burst of particle sparks, mimicking the Instagram/Twitter double-tap heart. |
| **Rolling Number Counter** <br>`rolling-number-counter` | 17.0 | — | An animated numeric counter that smoothly rolls from its current value to a new target, with per-digit odometer-style transitions for an engaging count-up effect. |
| **Bouncing Dots Loader** <br>`bouncing-dots-loader` | 17.0 | — | A classic three-dot typing/loading indicator with staggered vertical bounce and subtle opacity pulse, looping smoothly while content loads. Collapses to a gentle in-place opacity pulse when Reduce Motion is enabled. |
| **Animated Success Checkmark Draw** <br>`animated-success-checkmark-draw` | 17.0 | — | A circular badge whose ring and checkmark stroke draw on with a spring, paired with a subtle scale pop. Ideal for confirming a completed payment, save, or upload. |
| **Confetti Burst Celebration** <br>`confetti-burst-celebration` | 17.0 | — | A one-shot radial confetti explosion of colored rectangles that fly outward, spin, and fade. Trigger it from a counter binding so any milestone or success can fire a fresh burst. |
| **Shake Invalid Field Modifier** <br>`shake-invalid-field-modifier` | 17.0 | — | A reusable GeometryEffect plus view modifier that horizontally shakes any view to signal an invalid entry, driven by an incrementing trigger so each failed validation re-fires the wobble. Honors Reduce Motion. |

## Layout & Scaffolding

| Component | min iOS | Deps | What it is |
| --- | --- | --- | --- |
| **Settings Icon Accessory Row** <br>`settings-icon-accessory-row` | 17.0 | SF Symbols | A reusable settings row with a tinted SF Symbol badge, a title with optional subtitle, and a flexible trailing accessory (chevron, value text, toggle, or badge). Tappable variants behave as accessible buttons. |
| **Section Header with Trailing Action** <br>`section-header-trailing-action` | 17.0 | SF Symbols | A grouped-content section header showing a title (with optional count badge) on the left and a tappable trailing action like 'See All' or an icon button on the right. Works as a plain header above any content stack. |
| **Collapsing Hero Gradient Header** <br>`collapsing-hero-gradient-header` | 17.0 | — | A tall gradient hero header with title and subtitle that smoothly collapses into a compact, blurred title bar as the content scrolls up — driven purely by scroll geometry with no UIKit. Includes a safe-area-aware sticky bar. |
| **Dashboard Stat Tile Grid** <br>`dashboard-stat-tile-grid` | 17.0 | SF Symbols | An adaptive LazyVGrid of metric tiles that flows into as many columns as fit, each tile showing an SF Symbol, value, title, and an optional up/down trend delta with semantic coloring. Ideal as the top scaffold of an analytics or overview dashboard. |
| **Labeled Content Divider** <br>`labeled-content-divider` | 17.0 | SF Symbols | A horizontal separator with centered (or leading/trailing) text or an optional SF Symbol between two hairlines, for splitting form/list sections such as 'OR continue with' or dated feed breaks. Hairline color, label style, and alignment are all parameterized. |
| **Adaptive Two Pane Layout** <br>`adaptive-two-pane-layout` | 17.0 | — | A size-class-aware container that renders its primary and secondary content side-by-side (with a configurable split ratio) on regular-width devices like iPad and stacks them vertically on compact-width iPhones. Generic over any two views so it scaffolds detail screens, master/detail bodies, or media+info pairings. |

