import ApplicationController from './application_controller'
import Toastify from 'toastify-js'

export default class ToastController extends ApplicationController {
  static values = {
    messages: String
  }

  // eslint-disable-next-line @typescript-eslint/ban-types
  //message.messageValue!: String

  connect() {
    const messages = JSON.parse(this.messagesValue.valueOf())['messages'].reverse()
    //console.log(messages)
    messages.forEach((message: string) => {
      Toastify({
        text: message,
        duration: 2000
      }).showToast()
    })
  }
}