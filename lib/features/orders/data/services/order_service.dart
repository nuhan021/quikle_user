import 'package:quikle_user/core/utils/constants/enums/address_type_enums.dart';
import 'package:quikle_user/core/utils/constants/enums/delivery_enums.dart';
import 'package:quikle_user/core/utils/constants/enums/order_enums.dart';
import 'package:quikle_user/core/utils/constants/enums/payment_enums.dart';
import 'package:quikle_user/core/utils/constants/image_path.dart';
import 'package:quikle_user/features/cart/data/models/cart_item_model.dart';
import 'package:quikle_user/features/home/data/models/product_model.dart';
import 'package:quikle_user/features/orders/data/models/order_model.dart';
import 'package:quikle_user/features/payout/data/models/delivery_option_model.dart';
import 'package:quikle_user/features/payout/data/models/payment_method_model.dart';
import 'package:quikle_user/features/profile/data/models/shipping_address_model.dart';

class OrderService {
  static List<OrderModel>? _persistentOrders;

  List<OrderModel> _getMockOrders() {
    return [
      OrderModel(
        orderId: '#12346',
        userId: 'user123',
        items: [
          CartItemModel(
            product: ProductModel(
              id: 'food_biryani_1',
              title: 'Chicken Biryani',
              description: 'Aromatic basmati rice with tender chicken pieces',
              price: '\$18',
              imagePath: ImagePath.foodIcon,
              categoryId: '1',
              subcategoryId: 'food_biryani',
              shopId: 'shop_1',
            ),
            quantity: 2,
          ),
          CartItemModel(
            product: ProductModel(
              id: 'meats_chicken_1',
              title: 'Chicken Breast',
              price: '\$12',
              description: 'Fresh boneless chicken breast',
              imagePath: ImagePath.groceryIcon,
              categoryId: '2',
              shopId: 'shop_2',
            ),
            quantity: 1,
          ),
          CartItemModel(
            product: ProductModel(
              id: 'meats_chicken_1',
              title: 'Chicken CUtlet',
              price: '\$12',
              description: 'Fresh boneless chicken breast',
              imagePath: ImagePath.groceryIcon,
              categoryId: '2',
              shopId: 'shop_2',
            ),
            quantity: 1,
          ),
        ],
        shippingAddress: ShippingAddressModel(
          id: '1',
          userId: 'user123',
          name: 'John Doe',
          address: '123 Main St',
          city: 'New York',
          state: 'NY',
          zipCode: '10001',
          phoneNumber: '+1234567890',
          type: AddressType.home,
          createdAt: DateTime.now(),
        ),
        deliveryOption: DeliveryOptionModel(
          type: DeliveryType.urgent,
          title: 'Express Delivery',
          description: '30-45 minutes',
          price: 0.0,
          isSelected: true,
        ),
        paymentMethod: const PaymentMethodModel(
          type: PaymentMethodType.cashOnDelivery,
          isSelected: true,
        ),
        subtotal: 31.0,
        deliveryFee: 0.0,
        total: 31.0,
        orderDate: DateTime.now().subtract(const Duration(minutes: 30)),
        status: OrderStatus.outForDelivery,
        estimatedDelivery: DateTime.now().add(const Duration(minutes: 15)),
      ),
      OrderModel(
        orderId: '#12345',
        userId: 'user123',
        items: [
          CartItemModel(
            product: ProductModel(
              id: 'food_pasta_1',
              title: 'Spaghetti Carbonara',
              description: 'Creamy pasta with bacon and cheese',
              price: '\$16',
              imagePath: ImagePath.foodIcon,
              categoryId: '1',
              subcategoryId: 'food_pasta',
              shopId: 'shop_1',
            ),
            quantity: 1,
          ),
          CartItemModel(
            product: ProductModel(
              id: 'meats_beef_1',
              title: 'Ground Beef',
              description: 'Fresh ground beef',
              price: '\$15',
              imagePath: ImagePath.groceryIcon,
              categoryId: '2',
              shopId: 'shop_2',
            ),
            quantity: 2,
          ),
        ],
        shippingAddress: ShippingAddressModel(
          id: '1',
          userId: 'user123',
          name: 'John Doe',
          address: '123 Main St',
          city: 'New York',
          state: 'NY',
          zipCode: '10001',
          phoneNumber: '+1234567890',
          type: AddressType.home,
          createdAt: DateTime.now(),
        ),
        deliveryOption: DeliveryOptionModel(
          type: DeliveryType.combined,
          title: 'Standard Delivery',
          description: '30-45 minutes',
          price: 0.0,
          isSelected: true,
        ),
        paymentMethod: const PaymentMethodModel(
          type: PaymentMethodType.paytm,
          isSelected: true,
        ),
        subtotal: 46.0,
        deliveryFee: 0.0,
        total: 46.0,
        orderDate: DateTime.now().subtract(const Duration(days: 1)),
        status: OrderStatus.delivered,
        estimatedDelivery: DateTime.now().add(const Duration(minutes: 30)),
      ),
      OrderModel(
        orderId: '#12344',
        userId: 'user123',
        items: [
          CartItemModel(
            product: ProductModel(
              id: 'food_pizza_1',
              title: 'Margherita Pizza',
              description: 'Classic tomato sauce with fresh mozzarella',
              price: '\$16',
              imagePath: ImagePath.foodIcon,
              categoryId: '1',
              subcategoryId: 'food_pizza',
              shopId: 'shop_2',
            ),
            quantity: 1,
          ),
          CartItemModel(
            product: ProductModel(
              id: 'food_salad_1',
              title: 'Caesar Salad',
              description: 'Fresh romaine with Caesar dressing',
              price: '\$10',
              imagePath: ImagePath.foodIcon,
              categoryId: '1',
              subcategoryId: 'food_salad',
              shopId: 'shop_2',
            ),
            quantity: 1,
          ),
        ],
        shippingAddress: ShippingAddressModel(
          id: '1',
          userId: 'user123',
          name: 'John Doe',
          address: '123 Main St',
          city: 'New York',
          state: 'NY',
          zipCode: '10001',
          phoneNumber: '+1234567890',
          type: AddressType.home,
          createdAt: DateTime.now(),
        ),
        deliveryOption: DeliveryOptionModel(
          type: DeliveryType.split,
          title: 'Fast Delivery',
          description: '15-25 minutes',
          price: 0.0,
          isSelected: true,
        ),
        paymentMethod: const PaymentMethodModel(
          type: PaymentMethodType.googlePay,
          isSelected: true,
        ),
        subtotal: 26.0,
        deliveryFee: 0.0,
        total: 26.0,
        orderDate: DateTime.now().subtract(const Duration(days: 2)),
        status: OrderStatus.delivered,
        estimatedDelivery: DateTime.now().subtract(
          const Duration(days: 1, hours: 12),
        ),
      ),
      OrderModel(
        orderId: '#12343',
        userId: 'user123',
        items: [
          CartItemModel(
            product: ProductModel(
              id: '6',
              title: 'Frozen Pizza',
              price: '7.00',
              description: 'Delicious frozen pizza',
              imagePath: ImagePath.allIcon,
              categoryId: 'frozen',
              shopId: 'shop1',
            ),
            quantity: 3,
          ),
        ],
        shippingAddress: ShippingAddressModel(
          id: '1',
          userId: 'user123',
          name: 'John Doe',
          address: '123 Main St',
          city: 'New York',
          state: 'NY',
          zipCode: '10001',
          phoneNumber: '+1234567890',
          type: AddressType.home,
          createdAt: DateTime.now(),
        ),
        deliveryOption: DeliveryOptionModel(
          type: DeliveryType.urgent,
          title: 'Express Delivery',
          description: '30-45 minutes',
          price: 0.0,
          isSelected: true,
        ),
        paymentMethod: const PaymentMethodModel(
          type: PaymentMethodType.razorpay,
          isSelected: true,
        ),
        subtotal: 21.0,
        deliveryFee: 0.0,
        total: 21.0,
        orderDate: DateTime.now().subtract(const Duration(days: 3)),
        status: OrderStatus.cancelled,
        estimatedDelivery: DateTime.now().subtract(
          const Duration(days: 2, hours: 18),
        ),
      ),
    ];
  }

  Future<List<OrderModel>> getUserOrders(String userId) async {
    await Future.delayed(const Duration(milliseconds: 500));

    print('OrderService: Getting orders for user $userId');

    final mockOrders = _getMockOrders()
        .where((order) => order.userId == userId)
        .toList();
    final persistentOrders =
        _persistentOrders?.where((order) => order.userId == userId).toList() ??
        [];

    print(
      'OrderService: Found ${mockOrders.length} mock orders and ${persistentOrders.length} persistent orders',
    );

    final allOrders = [...persistentOrders, ...mockOrders];
    allOrders.sort((a, b) => b.orderDate.compareTo(a.orderDate));

    print('OrderService: Returning ${allOrders.length} total orders');

    return allOrders;
  }

  Future<OrderModel?> getOrderById(String orderId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    try {
      if (_persistentOrders != null) {
        try {
          return _persistentOrders!.firstWhere(
            (order) => order.orderId == orderId,
          );
        } catch (e) {}
      }

      return _getMockOrders().firstWhere((order) => order.orderId == orderId);
    } catch (e) {
      return null;
    }
  }

  Future<void> addOrder(OrderModel order) async {
    await Future.delayed(const Duration(milliseconds: 200));

    _persistentOrders ??= <OrderModel>[];
    _persistentOrders!.add(order);

    print(
      'OrderService: Added order ${order.orderId}. Total persistent orders: ${_persistentOrders!.length}',
    );
    print('OrderService: Order has ${order.items.length} items');
  }
}
