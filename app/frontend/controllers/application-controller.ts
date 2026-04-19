import { Controller } from '@hotwired/stimulus'

import { useElements } from '~/composables'

export default class ApplicationController extends Controller {
  removeElementsByClassName(className: string): void {
    const { removeElements } = useElements(this.element)
    removeElements({ className })
  }
}
