import { Component, input, effect, inject } from '@angular/core';
import { win } from '../browser'
import { FormsModule } from '@angular/forms';
import { MoviesService } from '../services/movies.service';

@Component({
  selector: 'app-movie',
  standalone: true,
  imports: [FormsModule],
  templateUrl: './movie.component.html',
  styleUrl: './movie.component.css'
})
export class MovieComponent {
  private moviesService = inject(MoviesService);
  private destroyAddMovieListener: (() => void) | undefined;

  title: string | undefined;
  releaseDate: string | undefined;

  id = input.required<number>()

  constructor() {
    const destroy = this.moviesService.onAddMovieConfirm(() => {
      if (this.title && this.releaseDate) {
        this.moviesService.addMovie(this.title, this.releaseDate);
      }
    });

    this.destroyAddMovieListener = destroy;

    effect(async () => {
      const res = await this.moviesService.fetchMovie(this.id());

      if (res) {
        const { title, releaseDate } = res;

        this.title = title;
        this.releaseDate = new Date(releaseDate).toISOString().split('T')[0]; // TODO this is not timezone-safe
      }
    });
  }

  ngOnDestroy() {
    if (this.destroyAddMovieListener) {
      this.destroyAddMovieListener();
      this.destroyAddMovieListener = undefined;
    }
  }
}
