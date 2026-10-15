
import 'dart:convert'; //Importiert Funtionen zum Umwandeln in und aus JSON
import 'dart:ui'; //Importiertgrundlegende Grafik- und UI-Funktion

import 'package:flutter/material.dart'; //Importiert Flutter-Bausteine für Oberflächen (coloer, widegets, etc.)
import 'package:shared_preferences/shared_preferences.dart'; //App kann damit kleine Daten und Einstelunngune lokal speichern

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const HouseholdApp());
} //richtet Fluter ein und startet die App
//Konstante für Farben, die in der App verwendet werden
const Color mint = Color(0xFF8FE0D0);
const Color turquoise = Color(0xFF20BDB5);
const Color deepTeal = Color(0xFF087F83);
const Color darkText = Color(0xFF174B4B);

const String iconPath = 'assets/images/app_icon.png'; //Konstante für Pfad zum App-Icon
const String startBackgroundPath = 'assets/images/Nuvia_Start.png'; //Konstante für Pfad zum Startbildschirm-Hintergrund

class HouseholdApp extends StatelessWidget { //defiert ein Widget für die App, das nicht verändert werden kann, beschreibt Aufbau
  const HouseholdApp({super.key}); //Konstruktor, reicht Schlüssel an übergeordnetes Widget weiter, Schlüssel dienen zur Unterscheidung

  @override
  Widget build(BuildContext context) { //build beshreibt die Oberfläche die gezeigt wird, Context enthält Info über Position im Widget-Baum
    return MaterialApp( //äußere Flutter-App Wideget; stellt z.b. Navigation, Thema und Startbildschirm bereit
      title: 'Haushalt', //App-Titel
      debugShowCheckedModeBanner: false, //entfernt das Debug-Banner in der oberen rechten Ecke
      theme: ThemeData( //legt das Design der App fest
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: turquoise,
          brightness: Brightness.light,
        ), //legt Farbpalette fest, die auf der Farbe "turquoise" basiert
        scaffoldBackgroundColor: mint, 
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          foregroundColor: darkText,
          elevation: 0, //keine Schatten unter der AppBar
          centerTitle: true,
        ), //legt Design der AppBar fest
        inputDecorationTheme: InputDecorationTheme( //legt Design der Eingabefelder fest
          filled: true,
          fillColor: Colors.white.withValues(alpha: 0.8),
          border: OutlineInputBorder( 
            borderRadius: BorderRadius.circular(16), //abrundung der Ecken radius 16
            borderSide: BorderSide.none,
          ),
        ),
      ),
      home: const StartScreen(), //legt Startscreen als erste sichtbare Seite fest
    );
  }
}

// --------------------------------------------------
// HINTERGRUND: türkiser Farbverlauf
// --------------------------------------------------

class GradientBackground extends StatelessWidget { //definiert unveränderliches Widget
  final Widget child; //speichert widget was innerhalb Verlauf angezeigt wird; final = kann nach Initialisierung nicht mehr verändert werden

  const GradientBackground({ //Konstruktor
    super.key,
    required this.child, //bedeutet, dass bei der Erstellung des Widgets ein Kind-Widget übergeben werden muss
  });

  @override
  Widget build(BuildContext context) { //beschreibt die Oberfläche, die gezeigt wird
    return Container( //Container (beinhaltet andere Widgets (Hintergrund, Inhalt, etc.))
      decoration: const BoxDecoration( //legt Design des Containers fest
        gradient: LinearGradient( //linearer Farbverlauf, der von oben links nach unten rechts verläuft
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFB7F1E6),
            Color(0xFF65D8CC),
            Color(0xFF20BDB5),
            Color(0xFF159B9E),
          ],
        ),
      ),
      child: child, //zeigt das übergebene Kind-Widget innerhalb des Containers/Hintergrund an
    );
  }
}

// --------------------------------------------------
// GLAS-EFFEKT FÜR BUTTONS
// --------------------------------------------------

class GlassButton extends StatelessWidget { //definiert unveränderliches Widget
  final String label; //Text, der auf dem Button angezeigt wird
  final IconData icon; //Icon, das auf dem Button angezeigt wird
  final VoidCallback onTap; //Funktion, die ausgeführt wird, wenn der Button gedrückt wird; VoideCallback = Funktion ohne Parameter und Rückgabewert

  const GlassButton({ //Konstruktor, der verlang, dass beim Erstellen alles drei Parameter übergeben werden
    super.key,
    required this.label,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) { //beschreibt die Oberfläche, die gezeigt wird
    return ClipRRect( //legt abgerundete Ecken für den Button fest; dadurch bleiben auch Effekte innerhalb der Ecken
      borderRadius: BorderRadius.circular(25), 
      child: BackdropFilter( //verwischt Inhalt
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Material( //erzeugt halbtransparenten Hintergrund für Glas-Effekt
          color: Colors.white.withValues(alpha: 0.28),
          child: InkWell( //macht den Button klickbar und zeigt visuelles Feedback beim Drücken
            onTap: onTap, //
            child: Container( //legt Größe, Innenabstand und Design des Buttons fest
              width: double.infinity,
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 24,
              ),
              decoration: BoxDecoration( //rundet Ecken ab und legt Rahmenfarbe und -stärke fest
                borderRadius: BorderRadius.circular(25),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.65),
                  width: 1.5,
                ),
              ),
              child: Row( //legt Inhalt des Buttons in einer Reihe an
                children: [
                  Icon(icon, size: 30, color: darkText), //zeigt das übergebene Icon an
                  const SizedBox(width: 18), //legt Abstand zwischen Icon und Text fest
                  Expanded( //nimmt den restlichen Platz ein, damit der Text nicht abgeschnitten wird
                    child: Text(
                      label,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: darkText,
                      ),
                    ),
                  ),
                  const Icon( //zeigt Pfeil-Icon am Ende des Buttons an
                    Icons.arrow_forward_ios_rounded,
                    color: darkText,
                    size: 18,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// --------------------------------------------------
// STARTBILDSCHIRM
// --------------------------------------------------

class StartScreen extends StatelessWidget { //definiert unveränderliches Widget
  const StartScreen({super.key});

  @override
  Widget build(BuildContext context) { //beschreibt die Oberfläche, die gezeigt wird
    return Scaffold( //legt Grundgerüst der Seite fest, z.b. AppBar, Body, FloatingActionButton
      body: GestureDetector( //GestureDetector erkennt Gesten wie Tippen, Wischen, etc. und reagiert darauf; reagiert auf den ganzen Bildschirm
        behavior: HitTestBehavior.opaque, //macht auch transparente Bereiche des Widgets klickbar
        onTap: () { //beim antippen wird eine Routine mit HomeScreen aufgerufen
          Navigator.of(context).pushReplacement( //öffnet HomeScreen und entfernt StartScreen aus dem Navigationsstapel, sodass der Benutzer nicht zurückkehren kann
            MaterialPageRoute(
              builder: (_) => const HomeScreen(), //legt HomeScreen als neue Seite fest
            ),
          );
        },
        child: SizedBox.expand( //nimmt den gesamten verfügbaren Platz ein
          child: Stack( //legt Widgets übereinander an
            fit: StackFit.expand, //Widgets werden so groß wie möglich gemacht
            children: [ //
              Image.asset( 
                startBackgroundPath, //zeigt das Startbild an, das im assets-Ordner gespeichert ist
                fit: BoxFit.cover, //
                errorBuilder: (_, __, ___) => Container( //zeigt Container an, wenn das Bild nicht gefunden wird
                  color: mint,
                  child: const Center(
                    child: Text(
                      'Startbild fehlt\nassets/images/Nuvia_Start.png',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: darkText),
                    ),
                  ),
                ),
              ),
              const Align( //legt Text am unteren Bildschirmrand an
                alignment: Alignment.bottomCenter,
                child: Padding( //legt Abstand zum unteren Bildschirmrand fest
                  padding: EdgeInsets.only(bottom: 55), //legt Abstand auf 55 fest
                  child: Text(
                    'Zum Öffnen tippen',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      shadows: [ //fügt Schatten hinzu, damit der Text besser lesbar ist
                        Shadow(
                          blurRadius: 8,
                          color: Colors.black54,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// --------------------------------------------------
// HAUPTMENÜ
// --------------------------------------------------

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) { //
    return Scaffold( //legt Grundgerüst fest
      body: GradientBackground( //legt Hintergrund fest
        child: SafeArea( //legt Bereich fest, der nicht von Systemleisten (Statusleiste, Navigation) überdeckt wird
          child: Padding( //
            padding: const EdgeInsets.all(25),
            child: Column( //legt Widgets in einer Spalte an
              mainAxisAlignment: MainAxisAlignment.center, //Widgets werden vertikal zentriert
              children: [
                const Icon( //zeigt Haus-Icon an
                  Icons.home_rounded,
                  size: 75,
                  color: darkText,
                ),
                const SizedBox(height: 12), //legt Abstand von 12 fest
                const Text( //zeigt Titel an
                  'Unser Zuhause',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: darkText,
                  ),
                ),
                const SizedBox(height: 12), //legt Abstand von 12 fest
                const Text( //zeigt Untertitel an
                  'Alles an seinem Platz.',
                  style: TextStyle(
                    fontSize: 16,
                    color: darkText,
                  ),
                ),
                const SizedBox(height: 45),
                GlassButton( //zeigt Button für Vorräte an
                  label: 'Vorräte',
                  icon: Icons.kitchen_rounded, //legt Icon für Vorräte fest
                  onTap: () => Navigator.push( //öffnet Vorräte, wenn der Button gedrückt wird
                    context,
                    MaterialPageRoute(
                      builder: (_) => const PantryScreen(), //legt Vorräte als neue Seite fest
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                GlassButton( //zeigt Button für Aufgaben an
                  label: 'Aufgaben',
                  icon: Icons.checklist_rounded,//legt Icon für Aufgaben fest
                  onTap: () => Navigator.push( //öffnet Aufgaben, wenn der Button gedrückt wird
                    context,
                    MaterialPageRoute(
                      builder: (_) => const TasksScreen(), //legt Aufgaben als neue Seite fest
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// --------------------------------------------------
// DATENSPEICHERUNG
// --------------------------------------------------

class LocalStore { //definiert eine Hilfsklasse für die lokale Datenspeicherung
  static const String pantryKey = 'household_pantry_v1'; //Konstante für den Schlüssel, unter dem die Vorräte gespeichert werden
  static const String tasksKey = 'household_tasks_v1';

  static Future<List<Map<String, dynamic>>> load(String key) async { //load lädt Daten zu einem Schlüssel; async, weil Zugriff auf Speicher dauert; Future = Wert wird erst in der Zukunft verfügbar sein; Zürückgegeben wird eine Liste von Maps, die String-Keys und dynamische Werte enthalten
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(key);
      //holt SharedPreferences-Instanz und liest den gespeicherten String/Text unter key; await = wartet, bis der async Zugriff abgeschlossen; raw = roher JSON-String, der die Daten enthält
    if (raw == null) return [];

    try {
      final decoded = jsonDecode(raw) as List; //wandelt JSON-STring wieder in Dart-Daten um
      return decoded //geht String durch, wandelt Einträge in Map<String, dynamic> um und dann zu Liste
          .map((item) => Map<String, dynamic>.from(item as Map))
          .toList();
    } catch (_) { //fängt Fehler ab, falls JSON-String nicht korrekt ist und gibt leere Liste zurück
      return []; //return leere Liste
    }
  }

  static Future<void> save( //nimmt einen key und eine Liste von Datensätzen entgegen
    String key,
    List<Map<String, dynamic>> items,
  ) async { //läuft async und kein wert zurück
    //holt Speicher und wandelt List mit jsonEncode um und speichert sie unter dem key
    final prefs = await SharedPreferences.getInstance(); 
    await prefs.setString(key, jsonEncode(items));
  }
}

// --------------------------------------------------
// GEMEINSAME HILFSFUNKTIONEN
// --------------------------------------------------

//Formatiert ein Datum als TT.MM.JJJJ für die Anzeige
String dateString(DateTime date) {
  final d = date.day.toString().padLeft(2, '0');
  final m = date.month.toString().padLeft(2, '0');
  return '$d.$m.${date.year}';
}
//Liest ein Datum im ISO-Format JJJJ-MM-TT ein
DateTime parseDate(String value) {
  final parts = value.split('-');
  return DateTime(
    int.parse(parts[0]),
    int.parse(parts[1]),
    int.parse(parts[2]),
  );
}
//Formatiert ein Datum als JJJJ-MM-TT für die Speicherung
String isoDate(DateTime date) {
  final m = date.month.toString().padLeft(2, '0');
  final d = date.day.toString().padLeft(2, '0');
  return '${date.year}-$m-$d';
}
//Gibt das heutige Datum ohne Uhrzeit zurück
DateTime today() {
  final now = DateTime.now();
  return DateTime(now.year, now.month, now.day);
}
//Prüft, ob ein Datum innerhalb der nächsten 5 Tage liegt
bool expiresSoon(String value) {
  final difference = parseDate(value).difference(today()).inDays;
  return difference >= 0 && difference <= 5;
}
//wandelt ISO-Datum in lesbares Format TT.MM.JJJJ um
String readableDate(String value) {
  return dateString(parseDate(value));
}
//öffnet einen Kalender, um ein Datum auszuwählen; bei Abbruch wird null zurückgegeben
Future<DateTime?> chooseDate(
  BuildContext context,
  DateTime initial,
) {
  return showDatePicker( //öffnet Kalenderdialog
    context: context,
    initialDate: initial,
    firstDate: DateTime(2020),
    lastDate: DateTime(2100),
    helpText: 'Datum auswählen',
    cancelText: 'Abbrechen',
    confirmText: 'Übernehmen',
    builder: (context, child) {
      return Theme(
        data: Theme.of(context).copyWith(
          colorScheme: ColorScheme.fromSeed(
            seedColor: turquoise,
          ),
        ),
        child: child!,
      );
    },
  );
}

// --------------------------------------------------
// VORRÄTE: LISTE
// --------------------------------------------------

class PantryScreen extends StatefulWidget { //Stateful
  const PantryScreen({super.key});

  @override
  State<PantryScreen> createState() => _PantryScreenState();
}

class _PantryScreenState extends State<PantryScreen> {
  List<Map<String, dynamic>> items = []; //Liste enthält Voratsdaten; jeder Eintrag ist eine Map mit Felder wie Name, MHD, Typ
  bool loading = true; //hält fest, ob fie Daten noch geladen werden

  //initState wird einmalig aufgerufen, wenn das Widget erstellt wird; hier startet das Laden der Vorratsdaten
  @override
  void initState() {
    super.initState(); 
    loadItems();
  }

  Future<void> loadItems() async { //lädt die Vorratsdaten aus dem lokalen Speicher; async, weil Zugriff auf Speicher dauert
    final loaded = await LocalStore.load(LocalStore.pantryKey); //wartet aufs Laden
    if (!mounted) return; //mounted prüft, ob das Widget noch im Widget-Baum ist; verhindert, dass nach dem Verlassen des Bildschirms noch setState aufgerufen wird
    setState(() { //aktualisiert Daten udn beenden Laden; setState sagt Flutter, dass Oberfläche neu aufgebaut werden muss
      items = loaded;
      loading = false;
    });
  }

  Future<void> saveItems() async { //saveItems speichert aktuelle Liste über LocalStore unter key; async, weil Zugriff auf Speicher dauert
    await LocalStore.save(LocalStore.pantryKey, items); //wartet aufs Speichern
  }

  Future<void> openEditor({
    Map<String, dynamic>? item,
    int? index,
  }) async { //öffnet Dialog; falls item und index übergeben werden, wird Eintrag bearbeitet, ohne neuanlegen
    final nameController = TextEditingController( //Controller verwaltet Textfeld; beim bearbeiten bisheriger Name; bei Hinzufügen startet Feld
      text: item?['name'] as String? ?? '', //falls item null ist, wird leerer String verwendet
    );
    //falls item null ist, wird MHD auf 7 Tage in der Zukunft gesetzt; sonst wird MHD aus item gelesen und in DateTime umgewandelt
    DateTime selectedDate = item == null
        ? today().add(const Duration(days: 7))
        : parseDate(item['mhd'] as String); //parseDate erwartet JJJJ-MM-TT, bei speichern durch isoDate erzeugt

    String type = item?['type'] as String? ?? 'Normal'; //lädt vorhandene Ernährungsart oder setzt Standardwert auf Normal

    final result = await showDialog<Map<String, dynamic>>( //öffnet Dialog und wartet auf Ergebnis; bei Abbruch wird null zurückgegeben
      context: context, //zeigt Dialog im aktuellen Kontext an
      builder: (dialogContext) { //legt Inhalt des Dialogs fest
        return StatefulBuilder( //ermöglicht Dialog selbst zu aktualisieren, ohne dass die gesamte Seite neu aufgebaut wird
          builder: (context, setDialogState) { //setDialogState wird verwendet, um den Zustand innerhalb des Dialogs zu aktualisieren
            return AlertDialog( //gibt Dialog zurück, kleines Fenster über aktuellem Bildschirm
              title: Text( //legt Titel des Dialogs fest; je nachdem, ob ein item übergeben wurde, wird der Titel angepasst
                item == null ? 'Vorrat hinzufügen' : 'Vorrat bearbeiten',
              ),
              content: SingleChildScrollView( //ermöglicht Scrollen, falls Inhalt zu groß für Dialog ist
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: nameController,
                      autofocus: true,
                      textCapitalization: TextCapitalization.sentences, //setzt erste Buchstaben von Sätzen automatisch groß
                      decoration: const InputDecoration( //legt Design des Eingabefelds fest
                        labelText: 'Name des Lebensmittels',
                        prefixIcon: Icon(Icons.restaurant_rounded),
                      ),
                    ),
                    const SizedBox(height: 16), //legt Abstand von 16 fest
                    ListTile( //legt Listeneintrag für MHD fest; zeigt Datum an und öffnet Kalender, wenn angeklickt
                      contentPadding: EdgeInsets.zero, //entfernt Standard-Innenabstand
                      title: const Text('MHD'),
                      subtitle: Text(dateString(selectedDate)),
                      trailing: const Icon(Icons.calendar_month_rounded),
                      onTap: () async { //öffnet Kalender, um Datum auszuwählen
                        final picked = await chooseDate(
                          context,
                          selectedDate,
                        );
                        if (picked != null) { //falls ein Datum ausgewählt wurde, wird es als neues MHD gesetzt
                          setDialogState(() => selectedDate = picked);
                        }
                      },
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>( //legt Dropdown-Menü für Ernährungsart fest
                      initialValue: type,
                      decoration: const InputDecoration(
                        labelText: 'Ernährungsart',
                      ),
                      items: const [
                        DropdownMenuItem( //legt Einträge für Dropdown-Menü fest
                          value: 'Normal',
                          child: Text('Normal'),
                        ),
                        DropdownMenuItem(
                          value: 'Vegetarisch',
                          child: Text('Vegetarisch'),
                        ),
                        DropdownMenuItem(
                          value: 'Vegan',
                          child: Text('Vegan'),
                        ),
                      ],
                      onChanged: (value) { //legt fest, was passiert, wenn ein Eintrag ausgewählt wird; value = ausgewählter Wert
                        if (value != null) {
                          setDialogState(() => type = value);
                        }
                      },
                    ),
                  ],
                ),
              ),
              actions: [ //legt Buttons am unteren Rand des Dialogs fest
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext), //schließt Dialog ohne Ergebnis zurückzugeben
                  child: const Text('Abbrechen'),
                ),
                FilledButton( //schließt Dialog und gibt Ergebnis zurück; falls Name leer ist, wird nichts zurückgegeben
                  onPressed: () {
                    final name = nameController.text.trim();
                    if (name.isEmpty) return;
                    Navigator.pop(dialogContext, { //scließt Dialog; gibt Daten als Map zurück; MHD im ISO-Format
                      'name': name,
                      'mhd': isoDate(selectedDate),
                      'type': type,
                    });
                  },
                  child: const Text('Speichern'), //legt Text des Buttons fest
                ),
              ],
            );
          },
        );
      },
    );

    nameController.dispose(); //gibt Ressourcen des Controllers frei, sobald Dialog geschlossen

    if (result == null || !mounted) return; //beim Abbruch gibt es kein Ergebnis; es wird geprüft ob Bildschirm noch aktiv ist, vor Zustandänderung

    setState(() { //fügt Eintrag hinzu oder ersetzt vorhandenen; dann speichern
      if (index == null) {
        items.add(result);
      } else {
        items[index] = result;
      }
    });
    await saveItems(); //Änderungen werden dauerhaft gespeichert
  }

  Future<void> deleteItem(int index) async { //Löscht nach Bestätigung
    final confirmed = await showDialog<bool>( //Zeigt Dialog und wartet auf Auswahl
      context: context, //verwendet aktuellen Kontext
      builder: (context) => AlertDialog( //erstellt ein kleines Fenster
        title: const Text('Vorrat löschen?'),
        content: Text('„${items[index]['name']}“ wird entfernt.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false), //schließt Dialog; meldet false, also keine Änderung
            child: const Text('Abbrechen'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true), //schließt Dialog; meldet true, also Eintrag wird gelöscht
            child: const Text('Löschen'),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) return; //Abbruch wenn keine Bestätigung oder Widget/Fenster nicht mehr verfügbar

    setState(() => items.removeAt(index)); //Entfernt den Eintrag und aktualisiert Oberfläche
    await saveItems(); //Speichert geänderte Liste dauerhaft
  }

  void showItemMenu(int index) { //Zeigt Aktionsmenü an
    showModalBottomSheet<void>( //Öffnet modales Menü am unteren Bildschirmrand
      context: context,
      showDragHandle: true, //Zeigt einen Ziehgriff zu zuschieben an
      builder: (context) => SafeArea( //Berücksichtigt sichere Bildschirmbereiche wie Systemleiste
        child: Wrap( //Ordnet Menü Inhalte passend zu ihrem Inhalt
          children: [
            ListTile(
              leading: const Icon(Icons.edit_rounded),
              title: const Text('Bearbeiten'),
              onTap: () {
                Navigator.pop(context); //Schließt das Menü
                openEditor(item: items[index], index: index); //Öffnet Bearbeitungsmenü für den Eintrag
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete_outline_rounded),
              title: const Text('Löschen'),
              onTap: () {
                Navigator.pop(context); //Schließt Menü
                deleteItem(index); //Startet Löschvorgang für den Eintrag
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) { //Erstellt Benutzeroberfläche für Vorräte
    return Scaffold( //Grundlegendes Seitenlayout
      body: GradientBackground(
        child: SafeArea( 
          child: Column(
            children: [
              AppBar( //Zeigt die obere App-Leiste an
                title: const Text('Vorräte'),
                backgroundColor: Colors.transparent,
                actions: [ //Enthält Aktionen auf der rechten Seite
                  IconButton(
                    tooltip: 'Vorrat hinzufügen', //zeigt bei längerer Berührung Erklärung
                    onPressed: () => openEditor(),
                    icon: const Icon(Icons.add_circle_outline_rounded),
                    iconSize: 30,
                  ),
                  const SizedBox(width: 8),
                ],
              ),
              Expanded( //Lässt Listenbereich verbleibenden Platz einnehmen
                child: loading //Prüft,ob Vorratsdaten noch geladen werden
                    ? const Center(child: CircularProgressIndicator()) //Zeigt während des Ladens ein Fortschrittanzeiger
                    : items.isEmpty //Prüft, ob Vorratsliste leer ist
                        ? const EmptyState( //Zeigt einen Hinweis an, wenn keine Einträge vorhanden
                            icon: Icons.kitchen_rounded,
                            text: 'Noch keine Vorräte eingetragen.',
                            hint: 'Tippe auf +, um etwas hinzuzufügen.',
                          )
                        : ListView.builder( //Erstellt scrollbare Liste, kann bei Bedarf aufgebaut werden
                            padding: const EdgeInsets.fromLTRB( //Legt Innenabstände fest
                              16, 8, 16, 24, //Abstände links, oben, rechts, unten
                            ),
                            itemCount: items.length, //Gib Anzahl Listenelemente
                            itemBuilder: (context, index) { //Erstellt das Listenelement für den jeweiligen Index
                              final item = items[index]; //Holt den Vorrat an der aktuellen Position aus der Liste
                              final soon = expiresSoon(item['mhd'] as String); //Prüft ob MHD bald erreicht ist
                              final expired = parseDate( //Wandelt das gespeicherte Datum in Datumsobjekt um
                                item['mhd'] as String, //Liest das MHD des Vorrats aus
                              ).isBefore(today()); //Prüft ob das Datum vor dem heutigem liegt

                              return Card( //Zeigt Vorrat als eine Karte 
                                color: Colors.white.withValues(alpha:0.84),
                                margin: const EdgeInsets.only(bottom: 10),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18),
                                ),
                                child: ListTile( //Ordnet Elemente innerhalb der Karte an
                                  onLongPress: () => showItemMenu(index),
                                  leading: Icon(
                                    Icons.restaurant_rounded,
                                    color: soon ? Colors.red : deepTeal,
                                    size: 28,
                                  ),
                                  title: Text(
                                    item['name'] as String,
                                    style: TextStyle(
                                      color: soon
                                          ? Colors.red.shade800
                                          : darkText,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  subtitle: Padding(
                                    padding: const EdgeInsets.only(top: 5),
                                    child: Column( //Untereinander anordnen
                                      crossAxisAlignment: 
                                          CrossAxisAlignment.start, //Richtet Inhalt linksbündig aus
                                      children: [ 
                                        Text(
                                          'MHD: ${readableDate(item['mhd'] as String)}', //Zeigt MHD in gut lesbarem Format an
                                          style: TextStyle(
                                            color: soon //Wählt Textfarbe abhängig davon, ob MHD erreicht
                                                ? Colors.red.shade800 //Wenn erreicht
                                                : darkText.withValues(alpha:0.8), //Wenn nicht
                                            fontWeight: soon
                                                ? FontWeight.bold //Dickgedruckt, wenn erreicht
                                                : FontWeight.normal,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Wrap( //Ordnet Kennzeichnungen an und lässt sie bei Bedarf in neue Zeile umbrechen
                                          spacing: 6, //Platz zweischen den zwei Labeln
                                          children: [
                                            Chip( //Zeigt den Vorratstyp als Kennzeichnung an
                                              label: Text(
                                                item['type'] as String, //Zeigt gespeicherten Typ an
                                              ),
                                              visualDensity:
                                                  VisualDensity.compact,
                                              backgroundColor: mint.withValues(alpha:
                                                0.5,
                                              ),
                                              side: BorderSide.none,
                                            ),
                                            if (expired)
                                              const Chip( //
                                                label: Text('Abgelaufen'),
                                                visualDensity:
                                                    VisualDensity.compact,
                                                backgroundColor:
                                                    Color(0xFFFFDADA),
                                                side: BorderSide.none,
                                              ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ), 
                                  //trailing: const Icon(
                                  //Icons.more_horiz_rounded,
                                  //color: darkText,
                                  //),
                                ),
                              );
                            },
                          ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// --------------------------------------------------
// AUFGABEN: LISTE
// --------------------------------------------------


//Fast alles wie bei Aufgabe: Vorrat
//Außer: Warnt nicht 5 Tage vorher, kein Label für abgelaufen, und Durschstreichfunktion
//Nur Durchstreichfunktion wird kommentiert
class TasksScreen extends StatefulWidget {
  const TasksScreen({super.key});

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  List<Map<String, dynamic>> items = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadItems();
  }

  Future<void> loadItems() async {
    final loaded = await LocalStore.load(LocalStore.tasksKey);
    if (!mounted) return;
    setState(() {
      items = loaded;
      loading = false;
    });
  }

  Future<void> saveItems() async {
    await LocalStore.save(LocalStore.tasksKey, items);
  }

  Future<void> openEditor({
    Map<String, dynamic>? item,
    int? index,
  }) async {
    final nameController = TextEditingController(
      text: item?['name'] as String? ?? '',
    );

    DateTime selectedDate = item == null
        ? today().add(const Duration(days: 1))
        : parseDate(item['due'] as String);

    String person = item?['person'] as String? ?? 'Beide';

    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Text(
                item == null ? 'Aufgabe hinzufügen' : 'Aufgabe bearbeiten',
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: nameController,
                      autofocus: true,
                      textCapitalization: TextCapitalization.sentences,
                      decoration: const InputDecoration(
                        labelText: 'Was ist zu tun?',
                        prefixIcon: Icon(Icons.edit_note_rounded),
                      ),
                    ),
                    const SizedBox(height: 16),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Text('Fällig bis'),
                      subtitle: Text(dateString(selectedDate)),
                      trailing: const Icon(Icons.calendar_month_rounded),
                      onTap: () async {
                        final picked = await chooseDate(
                          context,
                          selectedDate,
                        );
                        if (picked != null) {
                          setDialogState(() => selectedDate = picked);
                        }
                      },
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      initialValue: person,
                      decoration: const InputDecoration(
                        labelText: 'Wer ist zuständig?',
                      ),
                      items: const [
                        DropdownMenuItem(
                          value: 'Ich',
                          child: Text('Ich'),
                        ),
                        DropdownMenuItem(
                          value: 'H',
                          child: Text('H'),
                        ),
                        DropdownMenuItem(
                          value: 'Beide',
                          child: Text('Beide'),
                        ),
                      ],
                      onChanged: (value) {
                        if (value != null) {
                          setDialogState(() => person = value);
                        }
                      },
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext),
                  child: const Text('Abbrechen'),
                ),
                FilledButton(
                  onPressed: () {
                    final name = nameController.text.trim();
                    if (name.isEmpty) return;
                    Navigator.pop(dialogContext, {
                      'name': name,
                      'due': isoDate(selectedDate),
                      'person': person,
                      'done': item?['done'] as bool? ?? false,
                    });
                  },
                  child: const Text('Speichern'),
                ),
              ],
            );
          },
        );
      },
    );

    nameController.dispose();

    if (result == null || !mounted) return;

    setState(() {
      if (index == null) {
        items.add(result);
      } else {
        items[index] = result;
      }
    });
    await saveItems();
  }

  Future<void> toggleTask(int index) async { //Ändert den Erledigt-Status der Aufgabe an Position index
    setState(() { //Teilt Flutter mit, dass sich der Zustand geändert hat und Oberfläche neu aufgebaut werden muss
      items[index]['done'] = !(items[index]['done'] as bool? ?? false); //Wechselt den Status: false oder fehlend wird true; true wird false
    });
    await saveItems(); //Wartet, bis Änderung gespeichert ist
  }

  Future<void> deleteItem(int index) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Aufgabe löschen?'),
        content: Text('„${items[index]['name']}“ wird entfernt.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Abbrechen'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Löschen'),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) return;

    setState(() => items.removeAt(index));
    await saveItems();
  }

  void showItemMenu(int index) {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.edit_rounded),
              title: const Text('Bearbeiten'),
              onTap: () {
                Navigator.pop(context);
                openEditor(item: items[index], index: index);
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete_outline_rounded),
              title: const Text('Löschen'),
              onTap: () {
                Navigator.pop(context);
                deleteItem(index);
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientBackground(
        child: SafeArea(
          child: Column(
            children: [
              AppBar(
                title: const Text('Aufgaben'),
                backgroundColor: Colors.transparent,
                actions: [
                  IconButton(
                    tooltip: 'Aufgabe hinzufügen',
                    onPressed: () => openEditor(),
                    icon: const Icon(Icons.add_circle_outline_rounded),
                    iconSize: 30,
                  ),
                  const SizedBox(width: 8),
                ],
              ),
              Expanded(
                child: loading
                    ? const Center(child: CircularProgressIndicator())
                    : items.isEmpty
                        ? const EmptyState(
                            icon: Icons.checklist_rounded,
                            text: 'Noch keine Aufgaben eingetragen.',
                            hint: 'Tippe auf +, um eine Aufgabe anzulegen.',
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.fromLTRB(
                              16, 8, 16, 24,
                            ),
                            itemCount: items.length,
                            itemBuilder: (context, index) {
                              final item = items[index];
                              final done =
                                  item['done'] as bool? ?? false;
                              final due = parseDate(item['due'] as String);
                              final overdue =
                                  due.isBefore(today()) && !done;

                              return Card(
                                color: Colors.white.withValues(alpha:0.84),
                                margin: const EdgeInsets.only(bottom: 10),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18),
                                ),
                                child: ListTile( //Einzelne Aufgaben als Listeneinträge
                                  onTap: () => toggleTask(index), //Hakt Aufgabe ab oder macht Abhaken rückgängig
                                  onLongPress: () => showItemMenu(index),
                                  leading: Checkbox( //Zeigt links neben Aufgabentext Kästchen an
                                    value: done, //Legt fest Kästchen angehakt ist
                                    activeColor: deepTeal,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    onChanged: (_) => toggleTask(index), //Beim Antippen des Kästchen wird Erledigt-Status geändert
                                  ),
                                  title: Text( //Zeigt Namen der Aufgabe an
                                    item['name'] as String, //Liest Aufgabennamen aus aktuellem Listeneintrag
                                    style: TextStyle(
                                      color: darkText,
                                      decoration: done //Prüft ob Aufgabe erledigt ist
                                          ? TextDecoration.lineThrough //Wenn erledigt, wird der Text durchgestrichen
                                          : TextDecoration.none, //Wenn nicht erledigt, dann nicht durchgestrichen
                                      decorationThickness: 2, //Dicke des Strichs
                                      fontWeight: FontWeight.w600, //Macht Aufgabennamen etwas kräftiger
                                    ),
                                  ),
                                  subtitle: Padding(
                                    padding: const EdgeInsets.only(top: 5),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Bis: ${readableDate(item['due'] as String)}',
                                          style: TextStyle(
                                            color: overdue
                                                ? Colors.red.shade800
                                                : darkText.withValues(alpha: 0.8),
                                            fontWeight: overdue
                                                ? FontWeight.bold
                                                : FontWeight.normal,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Chip(
                                          avatar: const Icon(
                                            Icons.person_outline_rounded,
                                            size: 17,
                                          ),
                                          label: Text(
                                            item['person'] as String,
                                          ),
                                          visualDensity:
                                              VisualDensity.compact,
                                          backgroundColor: mint.withValues(alpha: 0.5),
                                          side: BorderSide.none,
                                        ),
                                      ],
                                    ),
                                  ),
                                  //trailing: const Icon(
                                  //Icons.more_horiz_rounded,
                                  //color: darkText,
                                  //),
                                ),
                              );
                            },
                          ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// --------------------------------------------------
// LEERE LISTEN
// --------------------------------------------------

class EmptyState extends StatelessWidget {
  final IconData icon;
  final String text;
  final String hint;

  const EmptyState({
    super.key,
    required this.icon,
    required this.text,
    required this.hint,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 64,
              color: darkText.withValues(alpha: 0.65),
            ),
            const SizedBox(height: 16),
            Text(
              text,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: darkText,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              hint,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: darkText.withValues(alpha: 0.8),
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

