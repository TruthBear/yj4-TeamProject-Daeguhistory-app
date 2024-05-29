import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project/src/utils/colors.dart';

class CategoryButton extends StatefulWidget {
  final String text;
  final VoidCallback? onTap;
  final bool categoryState;

  const CategoryButton({super.key, required this.text, this.onTap, required this.categoryState,});

  @override
  State<CategoryButton> createState() => _CategoryButtonState();
}

class _CategoryButtonState extends State<CategoryButton> {

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Column(
        children: [
          Text(
            widget.text,
            style: TextStyle(
              fontSize: 16,
              color: widget.categoryState ? PRIMARY_COLOR : Colors.black,
              fontWeight: widget.categoryState ? FontWeight.bold : null,
            ),
          ),
          SizedBox(
            height: 3,
          ),
          Container(
            width: 5,
            height: 5,
            decoration: BoxDecoration(
                color: widget.categoryState ? PRIMARY_COLOR : PRIMARY_COLOR.withOpacity(0),
                borderRadius: BorderRadius.circular(50)
            ),
          )
        ],
      ),
    );
  }
}
