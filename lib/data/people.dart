class Person {
  final String name;
  final String phone;
  final String picture;
  const Person(this.name, this.phone, this.picture);
}

final List<Person> people = _people
    .map((e) => Person(
        e['name'] as String, e['phone'] as String, e['picture'] as String))
    .toList(growable: false);

final List<Map<String, Object>> _people = [
  {
    "_id": "66f91ff7d3072edaa35768a8",
    "index": 0,
    "guid": "3ded16a1-f4ec-445e-ad6f-5aab99b8c41c",
    "isActive": true,
    "balance": "\$3,439.05",
    "picture": "http://placehold.it/32x32",
    "age": 20,
    "eyeColor": "brown",
    "name": "Michael William",
    "gender": "male",
    "company": "CENTICE",
    "email": "michaelwilliam@centice.com",
    "phone": "+1 (972) 457-3947",
    "address": "457 Stryker Street, Whipholt, Vermont, 1402",
    "about":
        "Fugiat qui magna amet aute duis veniam mollit ea sit aute sint ut quis. Aliqua elit irure non dolore pariatur enim et dolore nulla occaecat id excepteur Lorem. Commodo non deserunt minim ullamco fugiat ipsum sint ad magna ipsum qui sunt dolor enim. Tempor duis esse elit magna cupidatat duis Lorem irure consequat anim aliqua. Commodo Lorem proident reprehenderit cupidatat sint officia aliquip.\r\n",
    "registered": "2024-06-01T05:40:49 -07:00",
    "latitude": 17.74619,
    "longitude": 58.186116,
    "tags": [
      "labore",
      "adipisicing",
      "Lorem",
      "cupidatat",
      "adipisicing",
      "quis",
      "duis"
    ],
    "friends": [
      {"id": 0, "name": "Schultz Aguirre"},
      {"id": 1, "name": "Marisol Hooper"},
      {"id": 2, "name": "Christian Ewing"}
    ],
    "greeting": "Hello, Michael William! You have 5 unread messages.",
    "favoriteFruit": "banana"
  },
  {
    "_id": "66f91ff7a7b405d3a9cf06c1",
    "index": 1,
    "guid": "be4038e3-a330-4157-a0b1-1025bb149e7f",
    "isActive": false,
    "balance": "\$2,753.87",
    "picture": "http://placehold.it/32x32",
    "age": 20,
    "eyeColor": "blue",
    "name": "Castaneda Bailey",
    "gender": "male",
    "company": "SOLGAN",
    "email": "castanedabailey@solgan.com",
    "phone": "+1 (870) 547-2954",
    "address": "829 Bethel Loop, Croom, Puerto Rico, 9193",
    "about":
        "Consequat aliqua eiusmod ea commodo velit officia. Quis voluptate minim adipisicing consequat est ea cillum cillum reprehenderit proident officia occaecat. Eu amet est pariatur aliquip amet. Anim est eiusmod incididunt aliqua sint dolore ut cillum est occaecat dolore excepteur proident commodo.\r\n",
    "registered": "2020-03-28T07:29:27 -07:00",
    "latitude": -34.509078,
    "longitude": 75.824265,
    "tags": ["ullamco", "elit", "ad", "incididunt", "dolor", "anim", "commodo"],
    "friends": [
      {"id": 0, "name": "Vang Barnett"},
      {"id": 1, "name": "Carney Burton"},
      {"id": 2, "name": "Pearl Cook"}
    ],
    "greeting": "Hello, Castaneda Bailey! You have 5 unread messages.",
    "favoriteFruit": "apple"
  },
  {
    "_id": "66f91ff78d036b74d45f6799",
    "index": 2,
    "guid": "72851de7-481c-43e5-9c41-528a87db88b5",
    "isActive": true,
    "balance": "\$3,979.73",
    "picture": "http://placehold.it/32x32",
    "age": 29,
    "eyeColor": "blue",
    "name": "Pat Dawson",
    "gender": "female",
    "company": "RODEOLOGY",
    "email": "patdawson@rodeology.com",
    "phone": "+1 (802) 498-3025",
    "address": "938 Sharon Street, Dotsero, West Virginia, 985",
    "about":
        "Amet ea mollit incididunt ea. Nostrud proident fugiat labore minim aliqua minim cillum veniam dolore Lorem Lorem in nostrud nulla. Quis non consectetur incididunt sint. Proident irure tempor ipsum eiusmod. In quis dolore aliquip culpa occaecat commodo nulla. Irure eu exercitation duis et occaecat sit duis aliquip esse mollit sunt ipsum esse magna. Deserunt quis quis nostrud ut velit consectetur consequat tempor nostrud consequat.\r\n",
    "registered": "2014-12-03T03:35:38 -07:00",
    "latitude": -43.563292,
    "longitude": -110.964645,
    "tags": [
      "cupidatat",
      "amet",
      "et",
      "elit",
      "consequat",
      "laboris",
      "pariatur"
    ],
    "friends": [
      {"id": 0, "name": "Marguerite Hatfield"},
      {"id": 1, "name": "Moreno Francis"},
      {"id": 2, "name": "Eddie Ray"}
    ],
    "greeting": "Hello, Pat Dawson! You have 9 unread messages.",
    "favoriteFruit": "banana"
  },
  {
    "_id": "66f91ff725327223d5936491",
    "index": 3,
    "guid": "c02a3d17-3a82-4fc3-9778-b8a79b04096c",
    "isActive": false,
    "balance": "\$1,778.43",
    "picture": "http://placehold.it/32x32",
    "age": 26,
    "eyeColor": "green",
    "name": "Barbara Mooney",
    "gender": "female",
    "company": "STROZEN",
    "email": "barbaramooney@strozen.com",
    "phone": "+1 (965) 430-2609",
    "address": "340 Noble Street, Gadsden, New York, 1288",
    "about":
        "Sint Lorem anim esse ex irure cupidatat reprehenderit nostrud ea aute aliqua. Do labore mollit elit veniam nulla elit commodo duis excepteur esse. Cillum consequat culpa et tempor in nulla veniam eu in aute. Veniam veniam in eiusmod voluptate enim proident. Eu magna occaecat dolore incididunt.\r\n",
    "registered": "2022-04-27T09:45:18 -07:00",
    "latitude": -27.386147,
    "longitude": 5.64114,
    "tags": [
      "cillum",
      "esse",
      "excepteur",
      "reprehenderit",
      "et",
      "ullamco",
      "veniam"
    ],
    "friends": [
      {"id": 0, "name": "Estrada Padilla"},
      {"id": 1, "name": "Lawrence Prince"},
      {"id": 2, "name": "Laverne Rutledge"}
    ],
    "greeting": "Hello, Barbara Mooney! You have 7 unread messages.",
    "favoriteFruit": "apple"
  },
  {
    "_id": "66f91ff782d4de38e32c7acf",
    "index": 4,
    "guid": "be5fdd34-aeec-4860-9ee5-14556c781880",
    "isActive": true,
    "balance": "\$2,194.08",
    "picture": "http://placehold.it/32x32",
    "age": 28,
    "eyeColor": "brown",
    "name": "Edith Howell",
    "gender": "female",
    "company": "EARTHWAX",
    "email": "edithhowell@earthwax.com",
    "phone": "+1 (905) 480-3576",
    "address": "198 Nolans Lane, Brandywine, Arizona, 3080",
    "about":
        "Mollit ut aute non sit id. Enim quis occaecat consequat mollit amet duis anim dolor cillum duis id labore. Minim laboris minim qui eiusmod laborum velit mollit laboris sit occaecat nisi. Consectetur duis ad nulla commodo sint ea voluptate consequat velit minim quis cillum ea sit.\r\n",
    "registered": "2024-01-04T09:40:47 -07:00",
    "latitude": 79.608994,
    "longitude": 165.540144,
    "tags": [
      "nisi",
      "elit",
      "cupidatat",
      "consequat",
      "dolor",
      "in",
      "officia"
    ],
    "friends": [
      {"id": 0, "name": "Vilma Pope"},
      {"id": 1, "name": "Heidi Heath"},
      {"id": 2, "name": "Barton Holman"}
    ],
    "greeting": "Hello, Edith Howell! You have 4 unread messages.",
    "favoriteFruit": "apple"
  }
];