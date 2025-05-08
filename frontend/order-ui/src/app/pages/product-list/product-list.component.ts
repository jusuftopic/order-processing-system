import { Component, OnInit } from '@angular/core';
import { Product } from '../../api/models/models';
import { ProductService } from '../../api/services/product.service';
import { Router } from '@angular/router';
import { MatToolbar } from '@angular/material/toolbar';
import { MatCard, MatCardContent, MatCardHeader, MatCardSubtitle, MatCardTitle } from '@angular/material/card';
import { NgForOf } from '@angular/common';
import { ErrorHandlerService } from '../../services/error-handler.service';

@Component({
  selector: 'app-product-list',
  imports: [
    MatToolbar,
    MatCard,
    NgForOf,
    MatCardHeader,
    MatCardContent,
    MatCardTitle,
    MatCardSubtitle
  ],
  templateUrl: './product-list.component.html',
  styleUrl: './product-list.component.scss',
  standalone: true
})
export class ProductListComponent implements OnInit {

  products: Product[] = [];

  constructor(private productService: ProductService,
              private router: Router,
              private errorHandler: ErrorHandlerService) {
  }

  ngOnInit() {
    this.loadProducts();
  }

  private loadProducts(): void {
    this.productService.getProducts().subscribe({
      next: (products) => this.products = products,
      error: (error) => this.errorHandler.handleError(error, 'Error loading products')
    });
  }

  protected openProduct(product: Product): void {
    this.router.navigate(['/product', product.id]);
  }
}
