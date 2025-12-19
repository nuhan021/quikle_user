/// Models for filtering and sorting products
class SortOption {
  final String id;
  final String label;
  final String icon;

  const SortOption({required this.id, required this.label, required this.icon});

  static const List<SortOption> options = [
    SortOption(id: 'relevance', label: 'Relevance', icon: '⭐'),
    SortOption(id: 'price_low_high', label: 'Price: Low to High', icon: '💰'),
    SortOption(id: 'price_high_low', label: 'Price: High to Low', icon: '💎'),
    SortOption(id: 'rating', label: 'Rating: High to Low', icon: '⭐'),
  ];
}

class FilterOption {
  final String id;
  final String label;
  final String icon;
  final bool isSelected;

  const FilterOption({
    required this.id,
    required this.label,
    required this.icon,
    this.isSelected = false,
  });

  FilterOption copyWith({bool? isSelected}) {
    return FilterOption(
      id: id,
      label: label,
      icon: icon,
      isSelected: isSelected ?? this.isSelected,
    );
  }

  static const List<FilterOption> quickFilters = [
    FilterOption(id: 'below_99', label: 'Below ₹99', icon: '₹'),
    FilterOption(id: '100_199', label: '₹100 - ₹199', icon: '₹'),
    FilterOption(id: '200_499', label: '₹200 - ₹499', icon: '₹'),
    FilterOption(id: 'above_500', label: 'Above ₹500', icon: '₹'),
  ];
}

class PriceRange {
  final double min;
  final double max;

  const PriceRange({required this.min, required this.max});
}

class FilterState {
  final String selectedSort;
  final List<String> selectedFilters;
  final PriceRange priceRange;
  final bool showInStockOnly;

  const FilterState({
    this.selectedSort = 'relevance',
    this.selectedFilters = const [],
    this.priceRange = const PriceRange(min: 0, max: 1000),
    this.showInStockOnly = false,
  });

  FilterState copyWith({
    String? selectedSort,
    List<String>? selectedFilters,
    PriceRange? priceRange,
    bool? showInStockOnly,
  }) {
    return FilterState(
      selectedSort: selectedSort ?? this.selectedSort,
      selectedFilters: selectedFilters ?? this.selectedFilters,
      priceRange: priceRange ?? this.priceRange,
      showInStockOnly: showInStockOnly ?? this.showInStockOnly,
    );
  }

  int get activeFiltersCount {
    int count = 0;
    if (selectedSort != 'relevance') count++;
    count += selectedFilters.length;
    if (showInStockOnly) count++;
    if (priceRange.min > 0 || priceRange.max < 1000) count++;
    return count;
  }

  bool get hasActiveFilters => activeFiltersCount > 0;

  void reset() {
    // This will be handled by the controller
  }
}
