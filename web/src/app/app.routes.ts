import { Routes } from '@angular/router';
import { HomeComponent } from './home/home.component';
import { AboutComponent } from './about/about.component';
import { GuardedPageComponent } from './guarded-page/guarded-page.component';
import { CanActivateRouteGuard } from './can-activate-route.guard';
import { NativeDelegateGuard } from './native-delegate.guard';
export const routes: Routes = [
  { path: '', canActivateChild: [NativeDelegateGuard], children: [
    { path: '', component: HomeComponent },
    { path: 'about', component: AboutComponent },
    { path: 'guarded-page', component: GuardedPageComponent, canActivate: [CanActivateRouteGuard] }
  ]}
];
