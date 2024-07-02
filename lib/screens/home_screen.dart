import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:pesse/providers/bottom_navigation_provider.dart';
import 'package:pesse/providers/member_provider.dart';
import 'package:pesse/providers/transaction_provider.dart';
import 'package:pesse/themes/colors.dart';
import 'package:pesse/themes/theme_extension.dart';
import 'package:pesse/utils/show_alert_dialog.dart';
import 'package:pesse/widgets/alert_dialog.dart';
import 'package:pesse/widgets/bottom_navigation_bar.dart';
import 'package:pesse/widgets/dropdown.dart';
import 'package:pesse/widgets/labelled_icon_button.dart';
import 'package:provider/provider.dart';

enum TransactionType {
  deposit,
  withdraw,
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final List<Map<String, String>> _images;
  late final List<Widget> _imageSliders;

  int _currentCarouselIndex = 0;
  final CarouselController _carouselController = CarouselController();

  int _selectedMemberId = 0;
  final TextEditingController _membersDropdownController =
      TextEditingController();

  final ValueNotifier<bool> _isMemberSelected = ValueNotifier<bool>(false);

  @override
  void initState() {
    Provider.of<BottomNavigationNotifier>(context, listen: false)
        .setCurrentIndex(0);

    Future.delayed(Duration.zero, () {
      Provider.of<MemberNotifier>(context, listen: false).getMembers();
    });

    _images = [
      {
        'text': 'Halo, Pessian!',
        'imageUrl':
            'https://images.unsplash.com/photo-1531592937781-344ad608fabf?w=1000'
      },
      {
        'text': 'Tabungan',
        'imageUrl':
            'https://images.unsplash.com/photo-1579621970563-ebec7560ff3e?w=1000'
      },
      {
        'text': 'Anggota',
        'imageUrl':
            'https://images.unsplash.com/photo-1517488629431-6427e0ee1e5f?w=1000'
      },
      {
        'text': 'Penarikan',
        'imageUrl':
            'https://images.unsplash.com/photo-1586430156076-4f400aeebef1?w=1000'
      },
    ];

    _imageSliders = _images.map((image) {
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 5.0),
        child: ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(5.0)),
          child: Stack(
            children: <Widget>[
              Image.network(
                image['imageUrl']!,
                fit: BoxFit.cover,
                width: 1000.0,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) {
                    return child;
                  }
                  return const Center(child: CircularProgressIndicator());
                },
              ),
              Positioned(
                bottom: 0.0,
                left: 0.0,
                right: 0.0,
                child: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Color.fromARGB(200, 0, 0, 0),
                        Color.fromARGB(0, 0, 0, 0)
                      ],
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                    ),
                  ),
                  padding: const EdgeInsets.symmetric(
                      vertical: 10.0, horizontal: 20.0),
                  child: Text(
                    image['text']!,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }).toList();

    super.initState();
  }

  @override
  void didChangeDependencies() {
    for (var image in _images) {
      precacheImage(NetworkImage(image['imageUrl']!), context);
    }

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PesseColors.surface,
      appBar: AppBar(
        backgroundColor: PesseColors.transparent,
        surfaceTintColor: PesseColors.transparent,
        elevation: 0,
        title: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                SvgPicture.asset(
                  'assets/images/logo.svg',
                  semanticsLabel: 'Pesse\'s Logo',
                  height: 25.0,
                ),
                GestureDetector(
                  onTap: () {
                    context.goNamed('profile');
                  },
                  child: ClipOval(
                    child: Image.asset(
                      'assets/images/default_person.jpg',
                      height: 35,
                      width: 35,
                      fit: BoxFit.cover,
                      cacheWidth: 35,
                      cacheHeight: 35,
                    ),
                  ),
                ),
              ],
            ),
            Text(
              'Beranda',
              style: context.titleMedium.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            const SizedBox(height: 10.0),
            _carousel(),
            const SizedBox(height: 20.0),
            Container(
              height: 40.0,
              decoration: const BoxDecoration(
                color: PesseColors.background,
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(40.0),
                ),
              ),
            ),
            Expanded(
              child: Container(
                color: PesseColors.background,
                padding: const EdgeInsets.only(
                    left: 20.0, right: 20.0, bottom: 20.0),
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          PesseLabelledIconButton(
                            icon: Icons.group_add,
                            label: 'Tambah Anggota',
                            onPressed: () {
                              context.pushNamed('member.add');
                            },
                          ),
                          PesseLabelledIconButton(
                            icon: Icons.search,
                            label: 'Cari Anggota',
                            onPressed: () {
                              context.goNamed('members.index');
                            },
                          ),
                          PesseLabelledIconButton(
                            icon: Icons.percent,
                            label: 'Pengaturan Bunga',
                            onPressed: () {
                              context.goNamed('interest');
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 20.0),
                      Container(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Setor Cepat',
                          style: context.titleMedium.copyWith(
                            fontWeight: FontWeight.bold,
                            color: PesseColors.primary,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          _transactionShortcutButton(
                            transactionType: TransactionType.deposit,
                            amount: 50000.0,
                          ),
                          _transactionShortcutButton(
                            transactionType: TransactionType.deposit,
                            amount: 100000.0,
                          ),
                          _transactionShortcutButton(
                            transactionType: TransactionType.deposit,
                            amount: 250000.0,
                          ),
                        ],
                      ),
                      const SizedBox(height: 20.0),
                      Container(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Tarik Cepat',
                          style: context.titleMedium.copyWith(
                            fontWeight: FontWeight.bold,
                            color: PesseColors.primary,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          _transactionShortcutButton(
                            transactionType: TransactionType.withdraw,
                            amount: 50000.0,
                          ),
                          _transactionShortcutButton(
                            transactionType: TransactionType.withdraw,
                            amount: 100000.0,
                          ),
                          _transactionShortcutButton(
                            transactionType: TransactionType.withdraw,
                            amount: 250000.0,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const PesseBottomNavigationBar(),
    );
  }

  Widget _carousel() {
    return Column(
      children: [
        CarouselSlider(
          items: _imageSliders,
          carouselController: _carouselController,
          options: CarouselOptions(
              autoPlay: true,
              enlargeCenterPage: true,
              aspectRatio: 2.0,
              viewportFraction: 0.75,
              initialPage: 0,
              enableInfiniteScroll: true,
              reverse: false,
              autoPlayInterval: const Duration(seconds: 3),
              autoPlayAnimationDuration: const Duration(milliseconds: 800),
              autoPlayCurve: Curves.fastOutSlowIn,
              enlargeFactor: 0.3,
              onPageChanged: (index, reason) {
                setState(() {
                  _currentCarouselIndex = index;
                });
              }),
        ),
        const SizedBox(height: 20.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: _images.asMap().entries.map((entry) {
            return GestureDetector(
              onTap: () => _carouselController.animateToPage(entry.key),
              child: Container(
                width: 8.0,
                height: 8.0,
                margin:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: (Theme.of(context).brightness == Brightness.dark
                          ? PesseColors.white
                          : PesseColors.black)
                      .withOpacity(
                          _currentCarouselIndex == entry.key ? 0.9 : 0.4),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _transactionShortcutButton({
    required TransactionType transactionType,
    required double amount,
  }) {
    String amountText = 'Rp${(amount.toInt() / 1000).toString()}k';
    String transactionTypeText =
        transactionType == TransactionType.deposit ? 'Setor' : 'Tarik';
    String title = '$transactionTypeText $amountText';

    return TextButton(
      onPressed: () {
        showPesseAlertDialog(
          context,
          title: title,
          content: Column(
            children: <Widget>[
              Container(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Anggota',
                  style: context.label,
                ),
              ),
              const SizedBox(height: 10.0),
              Consumer<MemberNotifier>(
                  builder: (context, memberNotifier, child) {
                return memberNotifier.isPending
                    ? const CircularProgressIndicator()
                    : PesseDropdownMenu(
                        dropdownMenuEntries:
                            memberNotifier.members.map((member) {
                          return DropdownMenuEntry<String>(
                            value: member.id.toString(),
                            label: member.name,
                          );
                        }).toList(),
                        dropdownController: _membersDropdownController,
                        onSelected: (String? memberId) {
                          setState(() {
                            _selectedMemberId = int.parse(memberId!);
                          });

                          if (_membersDropdownController.text == '' ||
                              _selectedMemberId == 0) {
                            _isMemberSelected.value = false;
                          } else {
                            _isMemberSelected.value = true;
                          }
                        },
                        selectedEntry: _selectedMemberId.toString(),
                      );
              }),
              const SizedBox(height: 10.0),
              ValueListenableBuilder(
                valueListenable: _isMemberSelected,
                builder: (context, value, child) {
                  return !value
                      ? Container(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Pilih anggota terlebih dahulu',
                            style: context.label.copyWith(
                              color: PesseColors.error,
                            ),
                          ),
                        )
                      : Container();
                },
              )
            ],
          ),
          actionLabel: transactionTypeText,
          type: transactionType == TransactionType.deposit
              ? PesseAlertDialogType.success
              : PesseAlertDialogType.error,
          actionOnPressed: () {
            if (_membersDropdownController.text == '' ||
                _selectedMemberId == 0) {
              _isMemberSelected.value = false;
            }

            if (_isMemberSelected.value) {
              Provider.of<TransactionNotifier>(context, listen: false)
                  .addMemberTransaction(
                memberId: _selectedMemberId,
                transactionAmount: amount,
                transactionTypeId:
                    transactionType == TransactionType.deposit ? 2 : 3,
              );
              context.goNamed('members.index');
              context.pushNamed(
                'member.details',
                pathParameters: {
                  'memberId': _selectedMemberId.toString(),
                },
              );
            }
          },
        );
      },
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(
          transactionType == TransactionType.deposit
              ? PesseColors.success
              : PesseColors.error,
        ),
        padding: MaterialStateProperty.all<EdgeInsets>(
          const EdgeInsets.all(15.0),
        ),
        shape: MaterialStatePropertyAll<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
        ),
      ),
      child: Text('Rp${((amount) ~/ 1000).toInt().toString()}k'),
    );
  }
}
