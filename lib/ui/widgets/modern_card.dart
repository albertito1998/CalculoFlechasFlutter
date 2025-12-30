/// Widget de tarjeta moderna con diseño consistente
///
/// Proporciona cards con estilos modernos y animaciones suaves
/// siguiendo Material Design 3.
library;

import 'package:flutter/material.dart';

/// Tarjeta moderna con efecto elevado
class ModernCard extends StatelessWidget {
  /// Contenido de la tarjeta
  final Widget child;

  /// Color de fondo (opcional)
  final Color? color;

  /// Padding interno
  final EdgeInsetsGeometry? padding;

  /// Acción al tocar (opcional)
  final VoidCallback? onTap;

  /// Elevación de la tarjeta
  final double elevation;

  /// Constructor
  const ModernCard({
    super.key,
    required this.child,
    this.color,
    this.padding,
    this.onTap,
    this.elevation = 1,
  });

  @override
  Widget build(BuildContext context) {
    final cardWidget = Card(
      elevation: elevation,
      color: color,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: padding ?? const EdgeInsets.all(16),
        child: child,
      ),
    );

    if (onTap != null) {
      return InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: cardWidget,
      );
    }

    return cardWidget;
  }
}

/// Tarjeta de resultado con estilo destacado
class ResultCard extends StatelessWidget {
  /// Título del resultado
  final String title;

  /// Valor del resultado
  final String value;

  /// Icono opcional
  final IconData? icon;

  /// Color del resultado (opcional)
  final Color? valueColor;

  /// Constructor
  const ResultCard({
    super.key,
    required this.title,
    required this.value,
    this.icon,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ModernCard(
      color: theme.colorScheme.primaryContainer.withValues(alpha: 0.3),
      elevation: 2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (icon != null) ...[
                Icon(
                  icon,
                  color: theme.colorScheme.primary,
                  size: 24,
                ),
                const SizedBox(width: 12),
              ],
              Expanded(
                child: Text(
                  title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: valueColor ?? theme.colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }
}

/// Tarjeta de error con estilo destacado
class ErrorCard extends StatelessWidget {
  /// Mensaje de error
  final String message;

  /// Constructor
  const ErrorCard({
    super.key,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ModernCard(
      color: theme.colorScheme.errorContainer.withValues(alpha: 0.3),
      elevation: 2,
      child: Row(
        children: [
          Icon(
            Icons.error_outline,
            color: theme.colorScheme.error,
            size: 24,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onErrorContainer,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Tarjeta de información/ayuda
class InfoCard extends StatelessWidget {
  /// Título de la información
  final String title;

  /// Contenido de la información
  final String content;

  /// Icono opcional
  final IconData icon;

  /// Constructor
  const InfoCard({
    super.key,
    required this.title,
    required this.content,
    this.icon = Icons.info_outline,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ModernCard(
      color: theme.colorScheme.secondaryContainer.withValues(alpha: 0.3),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                color: theme.colorScheme.secondary,
                size: 24,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.onSecondaryContainer,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSecondaryContainer.withValues(
                alpha: 0.8,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
