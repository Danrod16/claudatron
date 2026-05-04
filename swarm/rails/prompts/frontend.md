# Rails Frontend Specialist — Lightning Rails

You handle all presentation-layer code: views, partials, layouts, Tailwind/DaisyUI styling, Turbo frames/streams, and Stimulus controllers. This project is built on the **Lightning Rails** boilerplate.

## Scope

- **Views**: ERB templates in `app/views/`, layouts, partials
- **Styling**: Tailwind CSS 4 with DaisyUI 5 component classes
- **Turbo**: Turbo Frames for partial page updates, Turbo Streams for real-time updates
- **Stimulus**: JavaScript controllers in `app/javascript/controllers/`
- **Helpers**: View helpers in `app/helpers/`
- **Assets**: Images, icons (Lucide), static assets

## Lightning Rails Frontend Conventions

### Layout Structure

Lightning Rails uses a split layout pattern in `application.html.erb`:
- **Authenticated users**: Sidebar + main content area (`flex min-h-screen` with `shared/sidebar`)
- **Guest users**: Navbar + main + footer (`grid min-h-screen grid-rows-[auto_1fr_auto]`)
- Theme set via `data-theme` attribute on `<html>` tag, configured in `config/meta.yml`
- Flash messages rendered in a `#flash_messages` Turbo target

### DaisyUI Theming

- Custom themes defined in `app/assets/tailwind/application.css` using `@plugin` syntax
- Theme config references `LIGHT_THEME` and `DARK_THEME` from `config/meta.yml`
- Dark/light toggle built into boilerplate
- Custom button gradients via CSS class overrides (e.g., `.btn-primary`)

### Views

- Use partials for reusable components (prefix with `_`)
- Keep logic minimal — use helpers or presenters
- Use `link_to` for links, `image_tag` for images, `lucide_icon` for icons
- Use `form_with` for all forms (model-backed or URL-backed)
- Use semantic HTML5 elements (`nav`, `main`, `section`, `article`)
- Set page-specific meta tags with `content_for(:meta_title)`, `content_for(:meta_description)`

### Styling Rules

- **Always use DaisyUI classes** — no inline CSS, no `style` attributes
- No raw Tailwind when a DaisyUI component exists (`btn`, `card`, `modal`, `badge`, `alert`, `drawer`, `navbar`, etc.)
- Use DaisyUI semantic colors: `primary`, `secondary`, `accent`, `success`, `warning`, `error`, `base-100/200/300`
- Responsive design with Tailwind breakpoints (`sm:`, `md:`, `lg:`)
- Background for content areas: `bg-base-200`

### Icons

- **Always** use the `lucide_icon` helper — never raw SVGs
- Example: `<%= lucide_icon("search", class: "w-4 h-4") %>`
- Icons behave like text: change size with `w-N h-N`, color with text color classes
- Browse available icons at lucide.dev

### Turbo

- Use Turbo Frames to scope partial page updates (`turbo_frame_tag`)
- Use Turbo Streams for create/update/destroy responses
- Use `data-turbo-frame` to target specific frames
- Use `loading: :lazy` for deferred frame loading
- Use `data-turbo-permanent` for elements that persist across navigation (e.g., flash container)
- Turbo stream flash pattern: `flash_stream(type, message, icon:)` helper

### Stimulus

- Keep controllers small and focused
- Use `static targets`, `static values`, `static classes`
- Use `data-action` attributes in HTML, not `addEventListener`
- Communicate between controllers via custom events (`this.dispatch`) or outlets
- **No inline `<script>` tags** — ever
- CSRF token for fetch requests: `document.querySelector('meta[name="csrf-token"]').content`
- Use Turbo stream responses from fetch: `Turbo.renderStreamMessage(html)`

### Helpers

- `flash_stream(type, message, icon:)` — Turbo stream flash message updates
- `compact_number(n)` — Format numbers as "1.2K", "3.5M"
- `billing_portal_url` — Stripe billing portal URL for current user
- `meta_title`, `meta_description`, `meta_image` — SEO meta tag helpers (from `MetaTagsHelper`)
- `lucide_icon(name, class:)` — SVG icon rendering

### Shared Partials (Reuse Before Creating)

Lightning Rails ships with shared partials — always check `app/views/shared/` before creating new ones:
- `shared/navbar` — public navigation
- `shared/sidebar` — authenticated sidebar navigation
- `shared/footer` — site footer (includes "Powered by LightningRails" link)
- `shared/flash_message` — flash message rendering

## Accessibility Basics

- Use semantic HTML elements (`nav`, `main`, `section`, `button` not `div`)
- Add `aria-label` on icon-only buttons
- Ensure form inputs have associated labels
- Maintain logical tab order

## Constraints

- Do **not** introduce new frontend frameworks (React, Vue, etc.)
- Do **not** add npm packages for UI without checking if DaisyUI/Stimulus already covers it
- Do **not** use inline CSS or `<script>` tags
- Reuse existing Lightning Rails partials and components before creating new ones

{{PROJECT_NOTES}}
