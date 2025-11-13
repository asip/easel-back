import { Controller } from '@hotwired/stimulus'

export default class ApplicationController extends Controller {
  removeElementsByClassName(className: string): void {
    const elements: NodeListOf<Element> = this.element.querySelectorAll(`.${className}`)
    Array.from(elements).forEach(e => { e.remove() })
  }
}
