import 'package:flutter/material.dart';

/// Un Dropdown avec recherche (Autocomplete) qui supporte la validation de formulaire.
class SearchableDropdown<T extends Object> extends FormField<T> {
  final List<T> items;
  final String Function(T) displayStringForOption;
  final String label;
  final String hintText;
  final ValueChanged<T?>? onSelected;

  SearchableDropdown({
    super.key,
    required this.items,
    required this.displayStringForOption,
    super.initialValue,
    this.label = '',
    this.hintText = 'Rechercher...',
    this.onSelected,
    super.onSaved,
    super.validator,
    super.enabled = true,
  }) : super(
          builder: (FormFieldState<T> field) {
            return _SearchableDropdownField<T>(
              items: items,
              displayStringForOption: displayStringForOption,
              initialValue: field.value,
              label: label,
              hintText: hintText,
              onSelected: (T? value) {
                field.didChange(value); // Met à jour l'état du formulaire
                onSelected?.call(value);
              },
              errorText: field.errorText, // Affiche l'erreur de validation
              enabled: enabled,
            );
          },
        );
}

class _SearchableDropdownField<T extends Object> extends StatelessWidget {
  final List<T> items;
  final String Function(T) displayStringForOption;
  final T? initialValue;
  final String label;
  final String hintText;
  final ValueChanged<T?> onSelected;
  final String? errorText;
  final bool enabled;

  const _SearchableDropdownField({
    required this.items,
    required this.displayStringForOption,
    this.initialValue,
    required this.label,
    required this.hintText,
    required this.onSelected,
    this.errorText,
    required this.enabled,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Autocomplete<T>(
          optionsBuilder: (TextEditingValue textEditingValue) {
            if (textEditingValue.text.isEmpty) {
              return items;
            }
            return items.where((T option) {
              return displayStringForOption(option)
                  .toLowerCase()
                  .contains(textEditingValue.text.toLowerCase());
            });
          },
          displayStringForOption: displayStringForOption,
          initialValue: initialValue != null 
              ? TextEditingValue(text: displayStringForOption(initialValue!)) 
              : null,
          onSelected: (T selection) {
            onSelected(selection);
          },
          fieldViewBuilder: (BuildContext context, TextEditingController textEditingController, FocusNode focusNode, VoidCallback onFieldSubmitted) {
            return TextFormField(
              controller: textEditingController,
              focusNode: focusNode,
              enabled: enabled,
              decoration: InputDecoration(
                labelText: label,
                hintText: hintText,
                border: const OutlineInputBorder(),
                errorText: errorText, // Affiche le message d'erreur ici
                suffixIcon: const Icon(Icons.arrow_drop_down),
              ),
              onFieldSubmitted: (String value) {
                onFieldSubmitted();
              },
            );
          },
          optionsViewBuilder: (BuildContext context, AutocompleteOnSelected<T> onSelected, Iterable<T> options) {
            return Align(
              alignment: Alignment.topLeft,
              child: Material(
                elevation: 4.0,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxHeight: 200),
                  child: ListView.builder(
                    padding: EdgeInsets.zero,
                    itemCount: options.length,
                    itemBuilder: (BuildContext context, int index) {
                      final T option = options.elementAt(index);
                      return InkWell(
                        onTap: () {
                          onSelected(option);
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(displayStringForOption(option)),
                        ),
                      );
                    },
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}

