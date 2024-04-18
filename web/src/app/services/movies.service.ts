import { Injectable, inject } from '@angular/core';
import { NativeService } from './native.service';
import type { Movie } from '../types';

@Injectable({
  providedIn: 'root'
})
export class MoviesService {
  private native = inject(NativeService);

  constructor() { }

  fetchMovies() {
    return this.native.queryNative<undefined, Movie[]>('fetch-movies', undefined);
  }

  fetchMovie(id: number) {
    return this.native.queryNative<number, Movie>('fetch-movie', id);
  }

  addMovie(title: string, releaseDate: string) {
    return this.native.queryNative('add-movie', {
      title,
      releaseDate
    })
  }

  onMoviesChange(callback: (movies: Movie[]) => void) {
    return this.native.listenForNative<Movie[]>('fetch-movies-response', callback);
  }

  onAddMovieConfirm(callback: () => void) {
    return this.native.listenForNative<Movie[]>('add-movie-confirm-response', callback);
  }

  onAddMovieActivate(callback: () => void) {
    return this.native.listenForNative<Movie[]>('add-movie-activate-response', callback);
  }
}
