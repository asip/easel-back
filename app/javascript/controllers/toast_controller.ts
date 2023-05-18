import ApplicationController from "./application_controller"
import Toastify from 'toastify-js'

export default class ToastController extends ApplicationController {
  static values = { messages: String };

  messagesValue: String

  connect() {
    const messages = JSON.parse(this.messagesValue.valueOf())["messages"].reverse()
    //console.log(messages)
    messages.forEach(message => {
      Toastify({
        text: message,
        duration: 2000
        }).showToast();
    });
  }
}