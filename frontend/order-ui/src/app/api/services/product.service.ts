import { Injectable } from '@angular/core';
import { Product } from '../models/models';
import { Observable, of } from 'rxjs';

@Injectable({
  providedIn: 'root'
})
export class ProductService {

  private products: Product[] = [
    {
      id: 1,
      name: 'Smartwatch X',
      description: 'Waterproof smartwatch with GPS',
      price: 199,
      imageUrl: 'https://via.placeholder.com/150'
    },
    {
      id: 2,
      name: 'Wireless Headphones',
      description: 'Noise-cancelling headphones',
      price: 149,
      imageUrl: 'https://via.placeholder.com/150'
    }
  ];

  constructor() { }

  public getProducts(): Observable<Product[]> {
    return of(this.products);
  }

  public getProductById(id: number): Observable<Product | undefined> {
    return of(this.products.find(product => product.id === id));
  }
}
