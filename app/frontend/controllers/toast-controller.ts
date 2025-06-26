import ApplicationController from './application-controller'
import Toastify from 'toastify-js'


export default class ToastController extends ApplicationController {
  static values = {
    flashes: String
  }

  declare readonly flashesValue: string

  connect() {
    const flashes = this.flashesValue.valueOf() !== '' ? JSON.parse(this.flashesValue.valueOf()) as Record<string, string[]> : {}

    Object.keys(flashes).forEach(
      (flashType: string) => {
        flashes[flashType].reverse().forEach((message: string) => {
          Toastify({
            text: message,
            duration: 2000
          }).showToast()
        })
      }
    )
  }
}