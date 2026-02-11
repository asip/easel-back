import { Controller } from '@hotwired/stimulus'

import { useElement } from '../composables'

export default class ApplicationController extends Controller {
  removeElementsByClassName(className: string): void {
    const { removeElements } = useElement(this.element)
    removeElements({ className })
  }
}
