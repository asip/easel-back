export function useElements(el: Element) {
  const removeElements = ({ className }: { className: string }): void => {
    const elements: NodeListOf<Element> = el.querySelectorAll(`.${className}`)
    Array.from(elements).forEach((e) => {
      e.remove()
    })
  }

  return { removeElements }
}
