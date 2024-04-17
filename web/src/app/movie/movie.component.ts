import { Component } from '@angular/core';
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

  private confirmCallback = this.confirmAddMovie.bind(this);

  ngOnInit() {
    if (win) {
      win.addEventListener('confirm-add-movie', this.confirmCallback);
    }
  }

  ngOnDestroy() {
    if (win) {
      win.removeEventListener('confirm-add-movie', this.confirmCallback);
    }
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
