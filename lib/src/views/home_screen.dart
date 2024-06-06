import 'package:flutter/material.dart';
import 'package:project/src/utils/colors.dart';
import 'package:project/src/utils/provider_state.dart';
import 'package:project/src/utils/secure_storage.dart';
import 'package:project/src/utils/tour_list.dart';
import 'package:project/src/weiget/custom_text_form_field.dart';
import 'package:project/src/weiget/tour_select_button.dart';
import 'package:provider/provider.dart';
import '../weiget/category_button.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController SearchController = TextEditingController();
  bool categoryAll = true;
  bool categoryBuilding = false;
  bool categorySociety = false;
  bool categoryScienceAndTechnology = false;
  List<Widget> searchTourList = tourList
      .map(
        (tour) => TourSelectButton(
          title: tour["tourName"],
          category: tour["tourCategory"],
          tourDescription: tour["tourDescription"],
          image: tour["tourImage"],
          latlng: tour["latlng"],
        ),
      )
      .toList();


  String? filterName;
  String? filterCategory;

  late Map<String, bool> categoryState;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    categoryState = {
      "전체": categoryAll,
      "건축물": categoryBuilding,
      "사회": categorySociety,
      "과학 및 기술": categoryScienceAndTechnology,
    };

    SearchController.addListener(updateTourName);
  }

  Future<void> getTourTitle(BuildContext context) async {
    final String? title = await storage.read(key: SELETED_TOUR_KEY);
    context.read<TourTitle>().setTitle = title;
  }

  seletedCatogory(String category) {
    setState(() {
      categoryState.updateAll((key, value) => key == category);
    });
  }

  updateTour() {
    // 카테고리 필터
    final firstFilter = tourList
        .where((tour) => filterCategory != null
            ? tour["tourCategory"] == filterCategory
            : tour["tourCategory"].isNotEmpty)
        .toList();

    // 이름 필터
    final secondFilter = firstFilter
        .where((tour) => filterName != null
            ? tour["tourName"].startsWith(filterName)
            // item.startsWith(query)
            : tour["tourName"].isNotEmpty)
        .toList();

    searchTourList = secondFilter
        .map(
          (tour) => TourSelectButton(
            title: tour["tourName"],
            category: tour["tourCategory"],
            tourDescription: tour["tourDescription"],
            image: tour["tourImage"],
          ),
        )
        .toList();
  }

  updateTourCategory({String? category}) {
    setState(() {
      filterCategory = category;
    });
    updateTour();
  }

  updateTourName({String? tourName}) {
    setState(() {
      filterName = SearchController.text;
    });
    updateTour();
  }

  @override
  Widget build(BuildContext context) {

    // getTourTitle(context);
    return Scaffold(
      appBar: AppBar(
        title: Column(
          children: [
            Text(
              context.watch<TourTitle>().title == null
                  ? "투어를 선택해주세요"
                  : "현재 진행중인 투어",
              style: TextStyle(color: PRIMARY_COLOR, fontSize: 12),
            ),
            context.watch<TourTitle>().title == null
                ? Container()
                : Text("${context.watch<TourTitle>().title}")
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "원하시는 투어를",
                style: TextStyle(fontSize: 26, height: 0),
              ),
              Text(
                "선택해주세요 !",
                style: TextStyle(
                    fontSize: 26, fontWeight: FontWeight.bold, height: 0),
              ),
              SizedBox(
                height: 20,
              ),
              SizedBox(
                height: 45,
                child: CustomTextFormField(
                  controller: SearchController,
                  hintText: "가고싶은 투어를 검색해주세요",
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Text(
                "카테고리",
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  CategoryButton(
                    text: "전체",
                    onTap: () {
                      seletedCatogory("전체");
                      updateTourCategory();
                    },
                    categoryState: categoryState["전체"] == true ? true : false,
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  CategoryButton(
                    text: "건축물",
                    onTap: () {
                      seletedCatogory("건축물");
                      updateTourCategory(category: "건축물");
                    },
                    categoryState: categoryState["건축물"] == true ? true : false,
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  CategoryButton(
                    text: "사회",
                    onTap: () {
                      seletedCatogory("사회");
                      updateTourCategory(category: "사회");
                    },
                    categoryState: categoryState["사회"] == true ? true : false,
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  CategoryButton(
                    text: "과학 및 기술",
                    onTap: () {
                      seletedCatogory("과학 및 기술");
                    },
                    categoryState:
                        categoryState["과학 및 기술"] == true ? true : false,
                  ),
                  SizedBox(
                    width: 20,
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              ...searchTourList,
            ],
          ),
        ),
      ),
    );
  }
}

