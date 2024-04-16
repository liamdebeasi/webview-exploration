import { Component } from '@angular/core';
import { RouterLink } from '@angular/router';

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
  movies: Movie[] = [
    { title: "Kung Fu Panda 4", id: 0 },
    { title: "Sonic 3", id: 1 },
    { title: "Mean Girls", id: 2 },
    { title: "Tetris", id: 3 },
    { title: "Some other movie", id: 4 },
    { title: "Some other movie", id: 5 },
    { title: "Some other movie", id: 6 },
    { title: "Some other movie", id: 7 },
    { title: "Some other movie", id: 8 },
    { title: "Some other movie", id: 9 },
    { title: "Some other movie", id: 10 },
    { title: "Some other movie", id: 11 },
    { title: "Some other movie", id: 12 },
    { title: "Another one", id: 13 },
    { title: "One more movie", id: 14 },
    { title: "The last movie", id: 15 },
    { title: "Just kidding there are still more", id: 16 },
    { title: "Penguins of Madagascar", id: 17 },
    { title: "Ok this is the last one for real", id: 18 },
  ];
}
