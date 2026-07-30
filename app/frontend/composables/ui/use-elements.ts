export function useElements(el: Element) {
  const removeElements = ({ selector }: { selector: string }): void => {
    const elements: NodeListOf<Element> = el.querySelectorAll(selector)
    Array.from(elements).forEach((e) => {
      e.remove()
    })
  }

  return { removeElements }
}
