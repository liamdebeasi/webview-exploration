import { Component } from '@angular/core';
import { RouterLink } from '@angular/router';
import { win } from '../browser';

interface Movie {
  title: string;
  id: number;
}

@Component({
  selector: 'app-home',
  standalone: true,
  imports: [RouterLink],
  templateUrl: './home.component.html',
  styleUrl: './home.component.css'
})
export class HomeComponent {
  movies: Movie[] = [];

  private handlerCallback = this.refreshMovies.bind(this);

  ngOnInit() {
    if (win) {
      win.addEventListener('refresh-movies', this.handlerCallback);

      if (win && win.webkit) {
        win.webkit.messageHandlers.navigationMessageHandler.postMessage({
          type: 'requestMovies',
          data: 'plz'
        });
      }
    }
  }

  ngOnDestroy() {
    if (win) {
      win.removeEventListener('refresh-movies', this.handlerCallback);
    }
  }

  refreshMovies(ev: any) {
    this.movies = ev.detail as any;
  }
}
