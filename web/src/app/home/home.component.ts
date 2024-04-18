import { Component, inject } from '@angular/core';
import { RouterLink } from '@angular/router';
import { MoviesService } from '../services/movies.service';

import type { Movie } from '../types';

@Component({
  selector: 'app-home',
  standalone: true,
  imports: [RouterLink],
  templateUrl: './home.component.html',
  styleUrl: './home.component.css'
})
export class HomeComponent {
  private moviesService = inject(MoviesService);
  private destroyMoviesChangeListener: (() => void) | undefined;

  movies: Movie[] = [];

  constructor() {}

  async ngOnInit() {
    const res = await this.moviesService.fetchMovies();

    this.movies = res ?? [];

    const destroy = this.moviesService.onMoviesChange((movies) => {
      this.movies = movies;
    });

    this.destroyMoviesChangeListener = destroy;
  }

  ngOnDestroy() {
    if (this.destroyMoviesChangeListener) {
      this.destroyMoviesChangeListener();
      this.destroyMoviesChangeListener = undefined;
    }
  }
}
