import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lost and Found',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFFA6781),
          primary: const Color(0xFFFA6781),
        ),
        inputDecorationTheme: const InputDecorationTheme(
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Color(0xFFFA6781), width: 2.0),
          ),
          floatingLabelStyle: TextStyle(
            color: Color(0xFFFA6781),
            fontWeight: FontWeight.bold,
          ),
        ),
        textSelectionTheme: const TextSelectionThemeData(
          cursorColor: Color(0xFFFA6781),
          selectionHandleColor: Color(0xFFFA6781),
        ),
        textTheme: GoogleFonts.stackSansHeadlineTextTheme(),
      ),
      home: const MainPage(),
    );
  }
}

class AppColors {
  static const header = Color(0xFFFA6781);
  static const lostBadge = Color.fromARGB(255, 175, 48, 48);
  static const lostCard = Color(0xFFF8BABA);
  static const foundBadge = Color.fromARGB(255, 69, 161, 201);
  static const foundCard = Color(0xFFBAE7E4);
  static const actionButton = Color.fromARGB(255, 106, 220, 113);
  static const background = Color(0xFFFAE7CB);
}

//main

enum ItemStatus { lost, found }

class Item {
  String id;
  ItemStatus status;
  String name;
  String description;
  String location;
  String date;

  Item({
    required this.id,
    required this.status,
    required this.name,
    required this.description,
    required this.location,
    required this.date,
  });
}

//mainpage


class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final List<Item> _items = [];
  int _nextId = 1;

  // create
  void _addItem(Item newItem) {
    setState(() {
      newItem.id = (_nextId++).toString();
      _items.add(newItem);
    });
  }

  // upd
  void _updateItem(String id, Item updated) {
    setState(() {
      final index = _items.indexWhere((i) => i.id == id);
      updated.id = id;
      _items[index] = updated;
    });
  }

  // del
  void _deleteItem(String id) {
    setState(() {
      _items.removeWhere((i) => i.id == id);
    });
  }

  void _openItemForm({Item? existing}) {
    showDialog(
      context: context,
      builder: (_) => ItemFormDialog(
        existing: existing,
        onSubmit: (item) {
          if (existing == null) {
            _addItem(item);
          } else {
            _updateItem(existing.id, item);
          }
        },
      ),
    );
  }

  void _confirmDelete(Item item) {
    final isLost = item.status == ItemStatus.lost;
    final verb = isLost ? 'claimed' : 'returned';
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Mark as $verb?'),
        content: Text('This will remove "${item.name}" from the list.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              _deleteItem(item.id);
              Navigator.pop(context);
            },
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.header,
              foregroundColor: Colors.white,
            ),
            child: Text(isLost ? 'Claim' : 'Return'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60.0),
        child: AppBar(
          backgroundColor: AppColors.header,
          elevation: 8.0,
          centerTitle: true,
          shadowColor: Colors.black,
          title: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Icon(
                Icons.search,
                color: Colors.white,
                size: 40,
              ),
              const SizedBox(width: 10),
              Stack(
                children: [
                  Text(
                    'LOST & FOUND',
                    style: TextStyle(
                      fontSize: 45,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                      foreground: Paint()
                        ..style = PaintingStyle.stroke
                        ..strokeWidth = 6.0
                        ..color = Colors.pink,
                    ),
                  ),
                  const Text(
                    'LOST & FOUND',
                    style: TextStyle(
                      fontSize: 45,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ],
          ),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(2.0),
            child: Container(
              color: Colors.pink,
              height: 2.0,
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Items',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                    color: AppColors.header,
                  ),
                ),
                OutlinedButton(
                  onPressed: () => _openItemForm(),
                  style: OutlinedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    side: const BorderSide(
                      color: Color.fromARGB(255, 235, 63, 120),
                      width: 2.0,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: const Text('+ Add Item'),
                ),
              ],
            ),
            const SizedBox(height: 12),
            // read
            Expanded(
              child: _items.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Text(
                            'No items yet :(',
                            style: TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.w900,
                              color: Color.fromRGBO(118, 10, 28, 1),
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Tap "+ Add Item" to add a lost or found item.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14,
                              color: Color.fromRGBO(0, 0, 0, 0.8),
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.separated(
                      itemCount: _items.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 14),
                      itemBuilder: (context, index) => ItemCard(
                        item: _items[index],
                        onEdit: () => _openItemForm(existing: _items[index]),
                        onResolve: () => _confirmDelete(_items[index]),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

//card

class ItemCard extends StatelessWidget {
  final Item item;
  final VoidCallback onEdit;
  final VoidCallback onResolve;

  const ItemCard({super.key, required this.item, required this.onEdit, required this.onResolve});

  @override
  Widget build(BuildContext context) {
    final isLost = item.status == ItemStatus.lost;
    final cardColor = isLost ? AppColors.lostCard : AppColors.foundCard;
    final badgeColor = isLost ? AppColors.lostBadge : AppColors.foundBadge;
    final label = isLost ? 'Lost' : 'Found';
    final actionLabel = isLost ? 'Claim' : 'Return';

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(color: badgeColor, borderRadius: BorderRadius.circular(6)),
                child: Text(label, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w300, letterSpacing: 1)),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  item.name,
                  style: GoogleFonts.notoSerif(fontSize: 38, fontWeight: FontWeight.w900),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              InkWell(
                onTap: onEdit,
                child: CircleAvatar(
                  radius: 16,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.edit, size: 16, color: badgeColor),
                ),
              ),
            ],
          ),
          const SizedBox(height: 5),
          const Divider(height: 0.5, thickness: 1, color: Colors.black26),
          const SizedBox(height: 8),
          Text.rich(
            TextSpan(
              style: const TextStyle(fontSize: 18, color: Color.fromARGB(175, 0, 0, 0)),
              children: [
                const TextSpan(
                  text: 'Description: ',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                TextSpan(text: item.description, style: const TextStyle(color: Color.fromARGB(175, 0, 0, 0))),
              ],
            ),
          ),
          Text.rich(
            TextSpan(
              style: const TextStyle(fontSize: 18, color: Color.fromARGB(175, 0, 0, 0)),
              children: [
                const TextSpan(
                  text: 'Location: ',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                TextSpan(text: item.location, style: const TextStyle(color: Color.fromARGB(175, 0, 0, 0))),
              ],
            ),
          ),
          Text.rich(
            TextSpan(
              style: const TextStyle(fontSize: 18, color:  Color.fromARGB(175, 0, 0, 0)),
              children: [
                const TextSpan(
                  text: 'Date: ',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                TextSpan(text: item.date, style: const TextStyle(color: Color.fromARGB(175, 0, 0, 0))),
              ],
            ),
          ),
          const SizedBox(height: 5),
          Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton(
              onPressed: onResolve,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.actionButton,
                foregroundColor: Colors.black,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              ),
              child: Text(actionLabel),
            ),
          ),
        ],
      ),
    );
  }
}

//formvalidation

class ItemFormDialog extends StatefulWidget {
  final Item? existing;
  final void Function(Item item) onSubmit;

  const ItemFormDialog({super.key, this.existing, required this.onSubmit});

  @override
  State<ItemFormDialog> createState() => _ItemFormDialogState();
}

class _ItemFormDialogState extends State<ItemFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late ItemStatus _status;
  late TextEditingController _nameController;
  late TextEditingController _descController;
  late TextEditingController _locationController;
  late TextEditingController _dateController;

  @override
  void initState() {
    super.initState();
    final e = widget.existing;
    _status = e?.status ?? ItemStatus.lost;
    _nameController = TextEditingController(text: e?.name ?? '');
    _descController = TextEditingController(text: e?.description ?? '');
    _locationController = TextEditingController(text: e?.location ?? '');
    _dateController = TextEditingController(text: e?.date ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descController.dispose();
    _locationController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  String? _requiredValidator(String? value) =>
      (value == null || value.trim().isEmpty) ? 'This field is required' : null;

  static const _monthNames = [
    'January', 'February', 'March', 'April', 'May', 'June',
    'July', 'August', 'September', 'October', 'November', 'December',
  ];

  String _formatDate(DateTime date) => '${_monthNames[date.month - 1]} ${date.day}, ${date.year}';

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(now.year - 5),
      lastDate: DateTime(now.year + 5),
    );
    if (picked != null) {
      setState(() => _dateController.text = _formatDate(picked));
    }
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      widget.onSubmit(Item(
        id: widget.existing?.id ?? '',
        status: _status,
        name: _nameController.text.trim(),
        description: _descController.text.trim(),
        location: _locationController.text.trim(),
        date: _dateController.text.trim(),
      ));
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.existing == null ? 'New Item' : 'Edit Item'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SegmentedButton<ItemStatus>(
                segments: const [
                  ButtonSegment(value: ItemStatus.lost, label: Text('Lost')),
                  ButtonSegment(value: ItemStatus.found, label: Text('Found')),
                ],
                selected: {_status},
                onSelectionChanged: (s) => setState(() => _status = s.first),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Item name'),
                validator: _requiredValidator,
              ),
              TextFormField(
                controller: _descController,
                decoration: const InputDecoration(labelText: 'Description'),
                validator: _requiredValidator,
              ),
              TextFormField(
                controller: _locationController,
                decoration: const InputDecoration(labelText: 'Location'),
                validator: _requiredValidator,
              ),
              TextFormField(
                controller: _dateController,
                readOnly: true,
                decoration: const InputDecoration(
                  labelText: 'Date',
                  suffixIcon: Icon(Icons.calendar_today),
                ),
                onTap: _pickDate,
                validator: _requiredValidator,
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
        FilledButton(
          onPressed: _submit,
          style: FilledButton.styleFrom(
            backgroundColor: AppColors.header,
            foregroundColor: Colors.white,
          ),
          child: const Text('Save'),
        ),
      ],
    );
  }
}