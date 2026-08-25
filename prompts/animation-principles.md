# Animation Principles — Design Philosophy

> This document answers "why" and "when". Read it once during onboarding or consult it when making animation and UX design decisions.
> For a quick implementation/review checklist, see `animation-checklist.md`.

## Purpose

Define principles for designing and implementing high-quality animation on the web, including UI animation, page transitions, component interaction, scroll-driven animation, micro-interactions, and the motion system of the overall interface.

The goal is **not** to create as much animation as possible, but to create motion that is **intentional, consistent, responsive, performant, and accessible**.

---

## Priority — order of precedence when principles conflict

Not every principle in this document has equal importance. When two principles conflict, resolve them in this order (highest → lowest):

1. **Accessibility / usability** — `prefers-reduced-motion`, do not break functionality, do not depend on hover for important actions.
2. **Correctness** — proper cleanup, no leaked timelines/listeners, no animation after component destruction, no unrelated behavior/API changes.
3. **Performance** — prefer `transform`/`opacity`, avoid layout thrashing.
4. **Existing project conventions** — established animation patterns/utilities.
5. **Visual consistency** — hierarchy, movement direction, spatial logic.
6. **Motion polish** — specific timing, easing style, bounce/stagger intensity.

In other words: (1)–(3) are **hard constraints — non-negotiable**; (4)–(6) are **soft constraints — adjustable based on aesthetics, brand, and conventions**. When a polish detail (for example, easing or bounce) conflicts with an established project convention, prefer the convention and discuss the change separately rather than breaking consistency in a single PR.

---

## 1. Animation is a form of communication

Animation should communicate meaning: visual hierarchy, cause and effect, spatial relationships, state changes, system feedback, continuity, focus, or progress.

Do not add animation merely because an element *can* be animated. Every important animation should have a clear purpose. If removing it does not reduce usability or understanding, reconsider whether it is actually necessary.

## 2. Understand the interface before designing animation

Before implementation: inspect the current UI, identify the primary visual hierarchy and expected user actions, inspect existing animation patterns/utilities, responsive behavior, accessibility requirements, and performance constraints.

Do not design animation separately from the interface. Motion should reinforce the existing design rather than compete with it.

## 3. Build a motion hierarchy

Not every element should receive the same level of animation:

- **Primary** — needs attention first: page title, primary CTA, main product image, important status, or the result of a primary interaction.
- **Secondary** — supports the primary content: description, metadata, secondary controls.
- **Tertiary** — decorative or finishing elements: decorative elements, ambient effects.

Primary elements should receive greater motion priority. Do not animate every element with equal intensity.

## 4. Design choreography before implementation

Treat animation as a sequence of movements, not an isolated effect. Define:
initial state → trigger → first movement → supporting movement → main emphasis → stable final state.

Every delay should contribute to hierarchy, cause and effect, or rhythm. Avoid arbitrary delays.

## 5. Timing

Timing communicates importance and the physical character of movement. Do not use the same duration for unrelated elements.

| Animation type | Duration |
| --- | ---: |
| Micro interaction | 100–200ms |
| Small state transition | 150–300ms |
| Component entrance | 250–500ms |
| Complex entrance sequence | 500–1200ms |
| Large visual transition | 400–1000ms |

These are reference starting points, not hard rules. Adjust for movement distance, complexity, hierarchy, and interaction context. Do not sacrifice UX or visual intent merely to stay within a range.

## 6. Easing

Easing expresses the character of movement (fast response, smoothness, weight, lightness, physicality, playfulness, energy, restraint). Do not use the same easing for every animation.

Use clearer acceleration/deceleration for large movements and lighter easing for micro-interactions. Avoid excessive bounce/elastic behavior unless the product's visual language genuinely requires it.

## 7. Stagger, movement direction, and continuity

**Stagger** creates hierarchy and rhythm. Use it when multiple elements form a sequence or need to be revealed progressively. Avoid it when important content appears too late, when elements are unrelated, or when the pattern becomes repetitive.

**Movement direction** should have meaning: upward movement can suggest continuation; lateral movement can communicate spatial movement; scale can communicate focus/emphasis; fade can communicate appearance/disappearance. Maintain consistent spatial logic. If an element exits to the left, do not make a related destination appear from the opposite direction without a reason.

**Continuity** — animation should help users understand where an element came from, where it is going, what caused the state change, and how two states relate. Prefer transitions that explain change over unrelated visual effects.

## 8. Interaction feedback

Interactive elements (hover, focus, active, pressed, selected, expanded, loading, success, error, etc.) should provide appropriate and timely feedback. Feedback should match the action; a button click does not need cinematic animation unless the interaction genuinely requires it.

**Hover/pointer**: feedback should be fast, reversible, subtle, and interruptible. Do not create a new animation for every pointer event; prefer controlling the current animation or changing state. Never rely entirely on hover for important functionality because touch devices do not have traditional hover.

## 9. Scroll-driven animation

Scroll animation should support content rather than fight the user's scrolling behavior.

Prefer light parallax, progressive reveal, pinned storytelling when genuinely necessary, section transitions, and visual continuity.

Avoid excessive scroll intervention, animations that make content difficult to read, excessively long pinned sections, or animation that obstructs navigation. Users should always feel in control of scrolling.

## 10. Visual restraint

More animation does **not** mean better animation.

Avoid unnecessary bounce, excessive rotation/scale, continuous movement, animating every element, competing focal points, and distracting decorative motion.

A well-designed interface usually uses **less** motion than an amateur interface. Prefer **one strong, intentional movement** over ten unrelated movements.

This also applies to stagger (do not use the same value everywhere) and repetitive patterns such as `fade in + translateY + delay` applied mechanically to every component.

## 11. Animation rhythm

Consider anticipation, acceleration, deceleration, pause, overlap, repetition, and contrast. Not every animation needs to start and end independently; overlap between sequences can create more natural rhythm. Avoid making every animation fully synchronized.

---

## Core principle

Do not ask:

> "How should I animate this element?"

Ask:

> "When this state changes, what does the user need to understand or feel?"

Then choose the simplest motion that communicates that intent accurately.

**Animation succeeds when users perceive the experience rather than the implementation behind it.**
