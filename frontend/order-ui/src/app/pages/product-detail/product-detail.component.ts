import { Component, OnInit } from '@angular/core';
import { Product } from '../../api/models/models';
import { ActivatedRoute } from '@angular/router';
import { ProductService } from '../../api/services/product.service';
import { MatToolbar } from '@angular/material/toolbar';
import {
  MatCard,
  MatCardActions,
  MatCardContent,
  MatCardHeader,
  MatCardSubtitle,
  MatCardTitle
} from '@angular/material/card';
import { MatButton } from '@angular/material/button';
import { ErrorHandlerService } from '../../services/error-handler.service';

@Component({
  selector: 'app-product-detail',
  imports: [
    MatToolbar,
    MatCard,
    MatCardHeader,
    MatCardContent,
    MatCardActions,
    MatButton,
    MatCardTitle,
    MatCardSubtitle
  ],
  templateUrl: './product-detail.component.html',
  styleUrl: './product-detail.component.scss',
  standalone: true
})
export class ProductDetailComponent implements OnInit {
  product?: Product;

  constructor(private route: ActivatedRoute,
              private productService: ProductService,
              private errorHandler: ErrorHandlerService) {}


  ngOnInit() {
    this.loadProduct();
  }

  private loadProduct(): void {
    const productId = this.route.snapshot.paramMap.get('id');
    if (productId && !isNaN(Number(productId))) {
      this.productService.getProductById(Number(productId)).subscribe({
        next: (product) => this.product = product,
        error: (error) =>
          this.errorHandler.handleError(error, 'Error loading product')
      });
    }
  }
}
