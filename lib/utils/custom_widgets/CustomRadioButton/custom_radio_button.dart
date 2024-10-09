// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'CustomButton/ButtonTextStyle.dart';
import 'CustomButton/CustomListViewSpacing.dart';

// ignore: must_be_immutable
class CustomRadioButton<T> extends StatefulWidget {
  CustomRadioButton({
    super.key,
    this.buttonLables,
    this.buttonValues,
    this.buttonTextStyle = const ButtonTextStyle(),
    this.autoWidth = false,
    this.radioButtonValue,
    required this.unSelectedColor,
    this.unSelectedBorderColor,
    this.padding = 3,
    this.spacing = 0.0,
    required this.selectedColor,
    this.selectedBorderColor,
    this.height = 35,
    this.width = 100,
    this.enableButtonWrap = false,
    this.horizontal = false,
    this.enableShape = false,
    this.elevation = 10,
    this.defaultSelected,
    this.customShape,
    this.absoluteZeroSpacing = false,
    this.wrapAlignment = WrapAlignment.start,
  })  : assert(buttonLables?.length == buttonValues?.length,
            "Button values list and button lables list should have same number of eliments "),
        assert(buttonValues?.toSet().length == buttonValues?.length,
            "Multiple buttons with same value cannot exist");

  ///Orientation of the Button Group
  final bool horizontal;

  ///Values of button
  final List<T>? buttonValues;

  ///This option will make sure that there is no spacing in between buttons
  final bool absoluteZeroSpacing;

  ///Default value is 35
  final double height;
  double padding;

  ///Spacing between buttons
  double spacing;

  ///Default selected value
  final T? defaultSelected;

  ///Only applied when in vertical mode
  ///This will use minimum space required
  ///If enables it will ignore [width] field
  final bool autoWidth;

  ///Use this if you want to keep width of all the buttons same
  final double width;

  final List<String>? buttonLables;

  ///Styling class for label
  final ButtonTextStyle buttonTextStyle;

  final void Function(String)? radioButtonValue;

  ///Unselected Color of the button
  final Color unSelectedColor;

  ///Selected Color of button
  final Color selectedColor;

  ///Unselected Color of the button border
  final Color? unSelectedBorderColor;

  ///Selected Color of button border
  final Color? selectedBorderColor;

  /// A custom Shape can be applied (will work only if [enableShape] is true)
  final ShapeBorder? customShape;

  ///alignment for button when [enableButtonWrap] is true
  final WrapAlignment wrapAlignment;

  /// This will enable button wrap (will work only if orientation is vertical)
  final bool enableButtonWrap;

  ///if true button will have rounded corners
  ///If you want custom shape you can use [customShape] property
  final bool enableShape;
  final double elevation;

  @override
  _CustomRadioButtonState createState() => _CustomRadioButtonState();
}

class _CustomRadioButtonState extends State<CustomRadioButton> {
  String? _currentSelectedLabel;

  Color borderColor(index) =>
      (_currentSelectedLabel == widget.buttonLables?[index]
          ? widget.selectedBorderColor
          : widget.unSelectedBorderColor) ??
      Theme.of(context).primaryColor;

  @override
  void initState() {
    super.initState();
    if (widget.defaultSelected != null) {
      if (widget.buttonValues!.contains(widget.defaultSelected)) {
        int index = widget.buttonValues?.indexOf(widget.defaultSelected) ?? 0;
        _currentSelectedLabel = widget.buttonLables?[index];
      } else {
        throw Exception("Default Value not found in button value list");
      }
    }
  }

  List<Widget>? _buildButtonsColumn() {
    return widget.buttonValues?.map((e) {
      int index = widget.buttonValues?.indexOf(e) ?? 0;
      return Padding(
        padding: EdgeInsets.all(widget.padding),
        child: Card(
          margin: EdgeInsets.all(widget.absoluteZeroSpacing ? 0 : 4),
          color: _currentSelectedLabel == widget.buttonLables?[index]
              ? widget.selectedColor
              : widget.unSelectedColor,
          elevation: widget.elevation,
          shape: widget.enableShape
              ? widget.customShape ??
                  const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(50)),
                  )
              : null,
          child: SizedBox(
            height: widget.height,
            child: MaterialButton(
              shape: widget.enableShape
                  ? widget.customShape ??
                      OutlineInputBorder(
                        borderSide:
                            BorderSide(color: borderColor(index), width: 1),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(20)),
                      )
                  : OutlineInputBorder(
                      borderSide:
                          BorderSide(color: borderColor(index), width: 1),
                      borderRadius: BorderRadius.zero,
                    ),
              onPressed: () {
                widget.radioButtonValue!(e);
                setState(() {
                  _currentSelectedLabel = widget.buttonLables?[index];
                });
              },
              child: Center(
                child: Text(
                  widget.buttonLables?[index] ?? '',
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: widget.buttonTextStyle.textStyle.copyWith(
                    color: _currentSelectedLabel == widget.buttonLables?[index]
                        ? widget.buttonTextStyle.selectedColor
                        : widget.buttonTextStyle.unSelectedColor,
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    }).toList();
  }

  List<Widget>? _buildButtonsRow() {
    return widget.buttonValues?.map((e) {
      int index = widget.buttonValues?.indexOf(e) ?? 0;
      return Card(
        margin: EdgeInsets.all(widget.absoluteZeroSpacing ? 0 : 4),
        color: _currentSelectedLabel == widget.buttonLables?[index]
            ? widget.selectedColor
            : widget.unSelectedColor,
        elevation: widget.elevation,
        shape: widget.enableShape
            ? widget.customShape ??
                const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(50)),
                )
            : null,
        child: Container(
          height: widget.height,
          width: widget.autoWidth ? null : widget.width,
          constraints: const BoxConstraints(maxWidth: 250),
          child: MaterialButton(
            padding: EdgeInsets.zero,
            minWidth: 10,
            shape: widget.enableShape
                ? widget.customShape ??
                    OutlineInputBorder(
                      borderSide:
                          BorderSide(color: borderColor(index), width: 1),
                      borderRadius: const BorderRadius.all(Radius.circular(20)),
                    )
                : OutlineInputBorder(
                    borderSide: BorderSide(color: borderColor(index), width: 1),
                    borderRadius: BorderRadius.zero,
                  ),
            onPressed: () {
              widget.radioButtonValue!(e.toString());
              setState(() {
                _currentSelectedLabel = widget.buttonLables?[index];
              });
            },
            child: Center(
              child: Text(
                widget.buttonLables?[index] ?? '',
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: widget.buttonTextStyle.textStyle.copyWith(
                  color: _currentSelectedLabel == widget.buttonLables?[index]
                      ? widget.buttonTextStyle.selectedColor
                      : widget.buttonTextStyle.unSelectedColor,
                ),
              ),
            ),
          ),
        ),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.absoluteZeroSpacing) {
      widget.spacing = 0;
      widget.padding = 0;
    }
    return _buildRadioButtons();
  }

  _buildRadioButtons() {
    if (widget.horizontal) {
      return SizedBox(
        height: widget.height * ((widget.buttonLables?.length ?? 0) * 1.5) +
            widget.padding * 2 * (widget.buttonLables?.length ?? 0),
        child: Center(
          child: CustomListViewSpacing(
            spacing: widget.spacing,
            scrollDirection: Axis.vertical,
            children: _buildButtonsColumn(),
          ),
        ),
      );
    }
    if (!widget.horizontal && widget.enableButtonWrap) {
      return Center(
        child: Wrap(
          spacing: widget.spacing,
          direction: Axis.horizontal,
          alignment: widget.wrapAlignment,
          children: _buildButtonsRow()!,
        ),
      );
    }
    if (!widget.horizontal && !widget.enableButtonWrap) {
      return SizedBox(
        height: widget.height + widget.padding * 2,
        child: Center(
          child: CustomListViewSpacing(
            spacing: widget.spacing,
            scrollDirection: Axis.horizontal,
            children: _buildButtonsRow(),
          ),
        ),
      );
    }
  }
}
