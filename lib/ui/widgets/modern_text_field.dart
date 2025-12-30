/// Widget de campo de texto moderno y personalizado
///
/// Proporciona un TextField con diseño consistente y mejorado
/// siguiendo Material Design 3.
library;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Campo de texto moderno con estilo consistente
class ModernTextField extends StatelessWidget {
  /// Etiqueta del campo
  final String label;

  /// Texto de ayuda opcional
  final String? hint;

  /// Controlador del campo
  final TextEditingController controller;

  /// Icono prefijo
  final IconData? prefixIcon;

  /// Tipo de teclado
  final TextInputType? keyboardType;

  /// Formateadores de entrada
  final List<TextInputFormatter>? inputFormatters;

  /// Función de validación
  final String? Function(String?)? validator;

  /// Si el campo está habilitado
  final bool enabled;

  /// Número máximo de líneas
  final int? maxLines;

  /// Sufijo del campo (ej: unidades de medida)
  final String? suffix;

  /// Constructor
  const ModernTextField({
    super.key,
    required this.label,
    required this.controller,
    this.hint,
    this.prefixIcon,
    this.keyboardType,
    this.inputFormatters,
    this.validator,
    this.enabled = true,
    this.maxLines = 1,
    this.suffix,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return TextFormField(
      controller: controller,
      enabled: enabled,
      maxLines: maxLines,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        suffixText: suffix,
        prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
        filled: true,
        fillColor: enabled
            ? theme.colorScheme.surface
            : theme.disabledColor.withValues(alpha: 0.05),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: theme.colorScheme.outline.withValues(alpha: 0.5),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: theme.colorScheme.outline.withValues(alpha: 0.5),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: theme.colorScheme.primary,
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: theme.colorScheme.error,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: theme.colorScheme.error,
            width: 2,
          ),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: theme.disabledColor.withValues(alpha: 0.3),
          ),
        ),
      ),
      style: theme.textTheme.bodyLarge,
    );
  }
}

/// Campo de texto específico para números
class NumericTextField extends StatelessWidget {
  /// Etiqueta del campo
  final String label;

  /// Controlador del campo
  final TextEditingController controller;

  /// Icono prefijo
  final IconData? prefixIcon;

  /// Sufijo (unidad de medida)
  final String? suffix;

  /// Si permite decimales
  final bool allowDecimals;

  /// Si permite negativos
  final bool allowNegative;

  /// Función de validación adicional
  final String? Function(String?)? validator;

  /// Si está habilitado
  final bool enabled;

  /// Constructor
  const NumericTextField({
    super.key,
    required this.label,
    required this.controller,
    this.prefixIcon,
    this.suffix,
    this.allowDecimals = true,
    this.allowNegative = false,
    this.validator,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return ModernTextField(
      label: label,
      controller: controller,
      prefixIcon: prefixIcon ?? Icons.dialpad,
      suffix: suffix,
      enabled: enabled,
      keyboardType: TextInputType.numberWithOptions(
        decimal: allowDecimals,
        signed: allowNegative,
      ),
      inputFormatters: [
        if (!allowNegative) FilteringTextInputFormatter.deny(RegExp(r'-')),
        if (allowDecimals)
          FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*'))
        else
          FilteringTextInputFormatter.digitsOnly,
      ],
      validator: validator,
    );
  }
}
