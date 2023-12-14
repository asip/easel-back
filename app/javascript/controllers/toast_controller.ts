import ApplicationController from './application_controller'
import Toastify from 'toastify-js'

type Flashes = Record<string, string[]>

export default class ToastController extends ApplicationController {
  static values = {
    flashes: String
  }

  declare readonly flashesValue: string

  connect() {
    const flashes: Flashes = JSON.parse(this.flashesValue.valueOf()) as Flashes

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