# Animation — Implementation Checklist

> Use this for quick reference when implementing or reviewing PRs involving animation.
> For design philosophy and principles, see `animation-principles.md`.

## Conditional dependencies

- `vercel-react-view-transitions` — only when the task implements or reviews route/page transitions or shared-element transitions in React/Next.

Do not load the view-transition skill for ordinary component micro-interactions.

## Before coding

1. Inspect the current implementation in the relevant component/module.
2. Find existing similar animations in the repository (for example, `animations/`, shared hooks, or comparable components) before designing a new one. Prefer an existing pattern when it solves the same problem; do not create a new animation utility merely because the task sounds new.
3. Identify the trigger, choreography, timing, and easing.
4. Identify responsive behavior and reduced-motion behavior.
5. Identify cleanup requirements (unmount, route change, viewport change).

Then implement the **smallest possible** architecture that produces the desired animation.
Do not create unnecessary abstractions, modify unrelated code, or add dependencies without a valid reason.

## Performance

- Prefer animating `transform` and `opacity`.
- Avoid unnecessary layout recalculation, DOM measurement loops, repeated synchronous DOM reads/writes, animating too many DOM nodes, and React state updates on every animation frame.
- Animation must not negatively affect scrolling, input responsiveness, rendering performance, or battery consumption.

## React integration

- Separate animation state from application state when possible.
- Avoid updating React state on every animation frame.
- Scope animation to the component; clean up timelines and listeners on unmount.
- Avoid unnecessary re-renders; reuse existing animation utilities.
- Prefer imperative animation libraries (for example, GSAP) for high-frequency animation instead of driving every frame through React state.

## Using GSAP (when the project already uses GSAP)

**GSAP is an implementation tool, not a design principle.** Always start from `animation-principles.md`, then select the appropriate GSAP feature; do not reverse that order.

- Follow the project's current architecture; do not change architecture without a reason.
- Prefer `timeline` for coordinated sequences; use labels when they improve readability.
- Use stagger when it serves hierarchy, not by default.
- In React, use `gsap.context()` or the project's established cleanup mechanism.
- Use `gsap.matchMedia()` when viewport-specific behavior is meaningful.
- Do not introduce GSAP when the project already has a suitable solution unless there is a clear technical or visual reason. Do not use a feature merely because it exists.

## Interruption handling

Interactive animation must handle repeated clicks, repeated hovers, navigation while animation is running, component unmount, route changes, and viewport changes.

- Do not allow animation to continue after the component has been destroyed.
- Do not accumulate timelines, event listeners, observers, or callbacks.

## Responsive

- Mobile often needs shorter sequences, smaller movement distances, fewer simultaneous effects, lighter parallax, and simpler choreography.
- Do not take desktop values and simply scale them down; design deliberately for mobile/touch.

## Accessibility

- Always respect `prefers-reduced-motion`.
- When reduced motion is enabled, remove unnecessary movement, reduce large transforms, and avoid excessive parallax — while **preserving** meaningful state changes, usability, and visual hierarchy. Reduced motion must not break the interaction.

## Preserve existing behavior / API

Animation tasks must remain within scope. Specifically:

- Do not change behavior unrelated to animation.
- Do not change layout, content, or accessibility semantics unless required by the task.
- Do not change the component's public API (props, events, DOM structure) unless genuinely necessary for the animation.

Example: a task such as `add hover animation to Button` should not also modify the Button API, change its DOM structure, or alter unrelated state management.

## Failure behavior

Animation must not break the application when it fails:

- Animation failure must not block interaction or the underlying business logic.
- Animation should degrade gracefully when the animation API is unavailable.
- Business logic must not depend on animation completion unless animation is genuinely a required part of the flow (rare). By default, the business action and animation should run independently rather than `onClick → animation → onComplete → business action`.

## Visual validation (when preview is available)

Do not consider animation complete based on code inspection alone. When a dev server/browser preview is available during the session:

- Run the relevant page/component and observe the animation in the actual rendered environment.
- Check the initial and final states.
- Check normal interaction speed and repeated interaction.
- Check mobile viewport and reduced-motion mode.
- Compare with the reference/design when available.

If no preview tool is available in the session, skip this step. It is not a commit-blocking condition; apply it whenever genuinely feasible.

## Before choosing animation for a new component

1. What does the user need to focus on?
2. What just changed?
3. What relationship needs to be communicated?
4. What movement direction has meaning?
5. How much movement is actually needed?
6. Does this element really need animation?

Use the simplest motion that effectively communicates the intended behavior.

---

## Definition of Done

### Design

- [ ] Animation has a clear purpose.
- [ ] Visual hierarchy is intentional (Primary/Secondary/Tertiary).
- [ ] Timing and easing fit the movement.
- [ ] Stagger has a purpose and is not used by default.
- [ ] Movement direction is consistent with the existing spatial logic.

### Engineering

- [ ] Animation cleanup is correct (unmount, route change).
- [ ] Repeated interaction does not create conflicts or overlapping timelines.
- [ ] Responsive behavior has been considered (mobile/touch).
- [ ] `prefers-reduced-motion` is supported.
- [ ] Performance is acceptable (no layout thrashing).
- [ ] Animation failure does not block underlying business logic.
- [ ] Behavior/API outside the task scope is unchanged.
- [ ] No unnecessary dependency was added.
- [ ] Existing project conventions are followed.

### Verification

- [ ] Type checking passes.
- [ ] Linting passes.
- [ ] Relevant tests pass.
- [ ] Visual behavior was checked when the environment allows it.
- [ ] Final diff contains no unrelated changes.

## Visual quality review (quick check)

| Aspect | Review question |
| --- | --- |
| Timing | Is it too fast/slow? Does the delay have meaning? |
| Hierarchy | Is user attention directed correctly? Does the primary element receive priority? |
| Easing | Does the movement feel natural and appropriate for its type? |
| Rhythm | Do sequences coordinate well? Is stagger/overlap intentional? |
| Stability | Is the final state stable? Is there unnecessary movement after completion? |
| Interaction | Is repeated interaction smooth? Can the animation be safely interrupted? |
| Responsive | Does it work well across mobile/touch and other viewports? |
| Accessibility | Does reduced motion work correctly? |
| Performance | Is the animation smooth? Are there unnecessary render/layout calculations? |
