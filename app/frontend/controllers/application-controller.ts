import { Controller } from '@hotwired/stimulus'

import { useElements } from '@/composables'

export default class ApplicationController extends Controller {
  removeElements(selector: string): void {
    const { removeElements } = useElements(this.element)
    removeElements({ selector })
  }
}
