import ApplicationController from './application-controller'

import { useToast } from '@/composables'

export default class ToastController extends ApplicationController {
  static values = {
    flashes: String,
  }

  declare readonly flashesValue: string

  connect(): void {
    const { toast } = useToast()

    const flashes = this.flashesValue
      ? (JSON.parse(this.flashesValue) as Record<string, string[]>)
      : {}

    toast.value = flashes
  }
}
