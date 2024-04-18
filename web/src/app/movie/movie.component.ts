import { Component, input, effect } from '@angular/core';
import { win } from '../browser'
import { FormsModule } from '@angular/forms';

@Component({
  selector: 'app-movie',
  standalone: true,
  imports: [FormsModule],
  templateUrl: './movie.component.html',
  styleUrl: './movie.component.css'
})
export class MovieComponent {

  name: string | undefined;
  releaseDate: string | undefined = '2024-04-16';

  id = input.required<number>()

  private confirmCallback = this.confirmAddMovie.bind(this);
  private receiveCallback = this.receiveMovie.bind(this);

  constructor() {
    if (win) {
      win.addEventListener('confirm-add-movie', this.confirmCallback);
      win.addEventListener('receive-movie', this.receiveCallback);
    }

    effect(() => {
      if (win && win.webkit) {
        const id = this.id();

        win.webkit.messageHandlers.navigationMessageHandler.postMessage({
          type: 'fetchMovie',
          data: id
        })
      }
    });
  }

  ngOnDestroy() {
    if (win) {
      win.removeEventListener('confirm-add-movie', this.confirmCallback);
      win.removeEventListener('receive-movie', this.receiveCallback);
    }
  }

  receiveMovie(ev: any) {
    this.name = ev.detail.title;
    // TODO
    this.releaseDate = new Date(ev.detail.releaseDate * 1000).toISOString().split('T')[0];
  }

  confirmAddMovie() {
    if (win && win.webkit) {
      win.webkit.messageHandlers.navigationMessageHandler.postMessage({
        type: 'addMovie',
        data: {
          name: this.name,
          releaseDate: this.releaseDate
        }
      })
    }
  }
}
