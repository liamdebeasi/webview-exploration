import { ComponentFixture, TestBed } from '@angular/core/testing';

import { GuardedPageComponent } from './guarded-page.component';

describe('GuardedPageComponent', () => {
  let component: GuardedPageComponent;
  let fixture: ComponentFixture<GuardedPageComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      imports: [GuardedPageComponent]
    })
    .compileComponents();
    
    fixture = TestBed.createComponent(GuardedPageComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
