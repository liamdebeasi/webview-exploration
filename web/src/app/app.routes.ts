import { Routes } from '@angular/router';
import { HomeComponent } from './home/home.component';
import { MovieComponent } from './movie/movie.component';
import { GuardedPageComponent } from './guarded-page/guarded-page.component';
import { CanActivateRouteGuard } from './can-activate-route.guard';
import { NativeDelegateGuard } from './native-delegate.guard';
export const routes: Routes = [
  { path: '', canActivateChild: [NativeDelegateGuard], children: [
    { path: '', component: HomeComponent },
    { path: 'movie', component: MovieComponent },
    { path: 'movie/:id', component: MovieComponent },
    { path: 'guarded-page', component: GuardedPageComponent, canActivate: [CanActivateRouteGuard] }
  ]}
];
