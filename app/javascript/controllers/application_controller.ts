import { Controller } from "stimulus"

export default class ApplicationController extends Controller {
  removeElementsByClassName(className){
    const elements: HTMLCollectionOf<Element> = this.element.getElementsByClassName(className);
    Array.from(elements).forEach(e => e.remove());
  }
}