import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:provider/provider.dart';
import 'UserProvider.dart';
import 'profilepage.dart';

class EditProfileScreen extends StatefulWidget {
  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  bool _isObscured = true;

  // Define TextEditingController for each field
  final TextEditingController emailController = TextEditingController();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController dobController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  String selectedGender = 'Male';
  String selectedCountry = 'Pakistan';
  String selectedCity = 'Karachi';

  final List<String> genderOptions = ['Male', 'Female'];

  final Map<String, List<String>> countryCityMap = {
    'Pakistan': ['Karachi', 'Lahore', 'Islamabad', 'Rawalpindi', 'Faisalabad', 'Peshawar', 'Multan', 'Gujranwala', 'Quetta'],
    'United States': ['New York', 'Los Angeles', 'Chicago', 'Houston', 'Phoenix', 'Philadelphia', 'San Antonio', 'San Diego', 'Dallas'],
    'Canada': ['Toronto', 'Montreal', 'Vancouver', 'Calgary', 'Edmonton', 'Ottawa', 'Quebec City', 'Winnipeg', 'Hamilton'],
    'United Kingdom': ['London', 'Birmingham', 'Manchester', 'Leeds', 'Glasgow', 'Liverpool', 'Sheffield', 'Bristol', 'Edinburgh'],
    'Australia': ['Sydney', 'Melbourne', 'Brisbane', 'Perth', 'Adelaide', 'Gold Coast', 'Canberra', 'Newcastle', 'Wollongong'],
    'India': ['Mumbai', 'Delhi', 'Bangalore', 'Hyderabad', 'Ahmedabad', 'Chennai', 'Kolkata', 'Surat', 'Pune'],
    'China': ['Shanghai', 'Beijing', 'Guangzhou', 'Shenzhen', 'Chengdu', 'Chongqing', 'Tianjin', 'Nanjing', 'Wuhan'],
    'Japan': ['Tokyo', 'Yokohama', 'Osaka', 'Nagoya', 'Sapporo', 'Kobe', 'Kyoto', 'Fukuoka', 'Kawasaki'],
    'Germany': ['Berlin', 'Hamburg', 'Munich', 'Cologne', 'Frankfurt', 'Stuttgart', 'Düsseldorf', 'Dortmund', 'Essen'],
    'France': ['Paris', 'Marseille', 'Lyon', 'Toulouse', 'Nice', 'Nantes', 'Strasbourg', 'Montpellier', 'Bordeaux'],
    'Brazil': ['São Paulo', 'Rio de Janeiro', 'Brasília', 'Salvador', 'Fortaleza', 'Belo Horizonte', 'Manaus', 'Curitiba', 'Recife'],
    'Russia': ['Moscow', 'Saint Petersburg', 'Novosibirsk', 'Yekaterinburg', 'Nizhny Novgorod', 'Kazan', 'Chelyabinsk', 'Omsk', 'Samara'],
    'Mexico': ['Mexico City', 'Guadalajara', 'Monterrey', 'Puebla', 'Tijuana', 'León', 'Ciudad Juárez', 'Cancún', 'Toluca'],
    'Italy': ['Rome', 'Milan', 'Naples', 'Turin', 'Palermo', 'Genoa', 'Bologna', 'Florence', 'Bari'],
    'Spain': ['Madrid', 'Barcelona', 'Valencia', 'Seville', 'Zaragoza', 'Málaga', 'Murcia', 'Palma de Mallorca', 'Las Palmas de Gran Canaria'],
    'Saudi Arabia': ['Riyadh', 'Jeddah', 'Mecca', 'Medina', 'Dammam', 'Al Khobar', 'Taif', 'Tabuk', 'Buraydah'],
    'United Arab Emirates': ['Dubai', 'Abu Dhabi', 'Sharjah', 'Ajman', 'Ras Al Khaimah', 'Fujairah', 'Umm Al Quwain', 'Al Ain', 'Khor Fakkan'],
    'Turkey': ['Istanbul', 'Ankara', 'Izmir', 'Bursa', 'Antalya', 'Gaziantep', 'Konya', 'Adana', 'Diyarbakir'],
    'Egypt': ['Cairo', 'Alexandria', 'Giza', 'Shubra El Kheima', 'Port Said', 'Suez', 'Luxor', 'Mansoura', 'Tanta'],
    'South Africa': ['Johannesburg', 'Cape Town', 'Durban', 'Pretoria', 'Port Elizabeth', 'Bloemfontein', 'Pietermaritzburg', 'Benoni', 'Tembisa'],
    'South Korea': ['Seoul', 'Busan', 'Incheon', 'Daegu', 'Daejeon', 'Gwangju', 'Suwon', 'Ulsan', 'Changwon'],
    'Indonesia': ['Jakarta', 'Surabaya', 'Bandung', 'Medan', 'Bekasi', 'Tangerang', 'Depok', 'Semarang', 'Palembang'],
    'Nigeria': ['Lagos', 'Kano', 'Ibadan', 'Abuja', 'Port Harcourt', 'Benin City', 'Kaduna', 'Maiduguri', 'Zaria'],
    'Argentina': ['Buenos Aires', 'Córdoba', 'Rosario', 'La Plata', 'Mar del Plata', 'San Miguel de Tucumán', 'Salta', 'Lanús', 'Santa Fe'],
    'Netherlands': ['Amsterdam', 'Rotterdam', 'The Hague', 'Utrecht', 'Eindhoven', 'Tilburg', 'Groningen', 'Almere', 'Breda'],
    'Belgium': ['Brussels', 'Antwerp', 'Ghent', 'Charleroi', 'Liège', 'Bruges', 'Schaerbeek', 'Namur', 'Anderlecht'],
    'Switzerland': ['Zürich', 'Geneva', 'Basel', 'Bern', 'Lausanne', 'Winterthur', 'Lucerne', 'St. Gallen', 'Lugano'],
    'Sweden': ['Stockholm', 'Gothenburg', 'Malmö', 'Uppsala', 'Västerås', 'Örebro', 'Linköping', 'Helsingborg', 'Jönköping'],
    'Norway': ['Oslo', 'Bergen', 'Trondheim', 'Stavanger', 'Bærum', 'Kristiansand', 'Fredrikstad', 'Tromsø', 'Sandnes']
  };

  @override
  void initState() {
    super.initState();
    fetchUserProfile();
  }

  Future<void> fetchUserProfile() async {
    final userId = Provider.of<UserProvider>(context, listen: false).userId; // Get userId from Provider
    final url = 'http://10.0.2.2:3001/api/user/profile/get/$userId'; // Update this based on your environment

    print('Fetching profile for userId: $userId');
    print('Request URL: $url');

    try {
      final response = await http.post(Uri.parse(url));

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        print('Parsed responseData: $responseData');

        if (responseData['data'] != null && responseData['data'].isNotEmpty) {
          final data = responseData['data'][0];
          print('Parsed data: $data');

          setState(() {
            emailController.text = data['email']?.toString() ?? '';
            firstNameController.text = data['fname']?.toString() ?? '';
            lastNameController.text = data['lname']?.toString() ?? '';
            dobController.text = data['dob']?.toString() ?? '';
            phoneNumberController.text = data['phoneNumber']?.toString() ?? '';
            passwordController.text = data['password']?.toString() ?? '';
            selectedGender = data['gender'] == 'F' ? 'Female' : 'Male';
            selectedCountry = data['country'] ?? 'Pakistan';
            selectedCity = data['city'] ?? 'Karachi';

            // Print values to the terminal
            print('email: ${emailController.text}');
            print('firstName: ${firstNameController.text}');
            print('lastName: ${lastNameController.text}');
            print('dob: ${dobController.text}');
            print('phoneNumber: ${phoneNumberController.text}');
            print('password: ${passwordController.text}');
            print('gender: $selectedGender');
            print('country: $selectedCountry');
            print('city: $selectedCity');
          });
        } else {
          print('No data found in the response');
        }
      } else {
        // Handle error
        print('Failed to load profile');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load profile: ${response.body}')),
        );
      }
    } catch (e) {
      // Handle error
      print('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  Future<void> saveUserProfile() async {
    final userId = Provider.of<UserProvider>(context, listen: false).userId; // Get userId from Provider
    final url = 'http://10.0.2.2:3001/api/user/profile/update/$userId'; // Use the correct URL

    print('Saving profile for userId: $userId');
    print('Request URL: $url');

    try {
      final response = await http.put(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'fname': firstNameController.text,
          'lname': lastNameController.text,
          'dob': dobController.text,
          'gender': selectedGender,
          'country': selectedCountry,
          'city': selectedCity,
          'password': passwordController.text,
          'phoneNumber': phoneNumberController.text,
        }),
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Profile updated successfully')),
        );
      } else {
        // Handle error
        print('Failed to save profile');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save profile: ${response.body}')),
        );
      }
    } catch (e) {
      // Handle error
      print('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  void dispose() {
    // Dispose controllers when the widget is disposed
    emailController.dispose();
    firstNameController.dispose();
    lastNameController.dispose();
    dobController.dispose();
    phoneNumberController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Image.asset(
            'images/logo.png', // Ensure this path is correct
            height: 60,
            color: Color(0xFF6FA68F)
        ),
      ),
      body: ListView(
        padding: EdgeInsets.all(20),
        children: [
          Center(
            child: Stack(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.grey[300],
                  child: Icon(Icons.person, size: 50, color: Colors.grey[600]),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.camera_alt, color: Colors.green[700]),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
          TextButton(
            onPressed: () {},
            child: Text("Edit Photo", style: TextStyle(color: Colors.green[700])),
          ),
          _buildTextField(firstNameController, "First Name", false),
          _buildTextField(lastNameController, "Last Name", false),
          _buildTextField(emailController, "Email", false),
          _buildDOBField(dobController, "DOB"),
          _buildDropdownField("Gender", selectedGender, genderOptions, (String? newValue) {
            setState(() {
              selectedGender = newValue!;
            });
          }),
          _buildDropdownField("Country", selectedCountry, countryCityMap.keys.toList(), (String? newValue) {
            setState(() {
              selectedCountry = newValue!;
              selectedCity = countryCityMap[selectedCountry]![0];
            });
          }),
          _buildDropdownField("City", selectedCity, countryCityMap[selectedCountry]!, (String? newValue) {
            setState(() {
              selectedCity = newValue!;
            });
          }),
          _buildPasswordTextField(passwordController, "Password"),
          _buildNumericTextField(phoneNumberController, "Phone Number"),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: saveUserProfile,
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF779A86),
              minimumSize: Size(double.infinity, 50),
            ),
            child: Text('Done',
              style: TextStyle(
                color: Colors.grey.shade800,
                fontSize: 15.0,
                fontWeight: FontWeight.bold,
              ),),
          ),
          SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => ProfileScreen()),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              minimumSize: Size(double.infinity, 50),
              side: BorderSide(color: Colors.red), // Setting the border color to red
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(45),
              ),
            ),
            child: Text('Cancel',
              style: TextStyle(
                color: Colors.grey.shade800,
                fontSize: 15.0,
                fontWeight: FontWeight.bold,
              ),),),
        ],
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, bool isPassword) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: Colors.white,
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xFF779A86)),
            borderRadius: BorderRadius.circular(10),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.green),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        obscureText: isPassword,
      ),
    );
  }

  Widget _buildNumericTextField(TextEditingController controller, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.number,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: Colors.white,
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xFF779A86)),
            borderRadius: BorderRadius.circular(10),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.green),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }

  Widget _buildPasswordTextField(TextEditingController controller, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: Colors.white,
          suffixIcon: IconButton(
            icon: Icon(_isObscured ? Icons.visibility_off : Icons.visibility),
            onPressed: () {
              setState(() {
                _isObscured = !_isObscured;
              });
            },
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xFF779A86)),
            borderRadius: BorderRadius.circular(10),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.green),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        obscureText: _isObscured,
      ),
    );
  }

  Widget _buildDOBField(TextEditingController controller, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: Colors.white,
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xFF779A86)),
            borderRadius: BorderRadius.circular(10),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.green),
            borderRadius: BorderRadius.circular(10),
          ),
          suffixIcon: IconButton(
            icon: Icon(Icons.calendar_today),
            onPressed: () async {
              DateTime? pickedDate = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(1900),
                lastDate: DateTime.now(),
              );
              if (pickedDate != null) {
                setState(() {
                  controller.text = "${pickedDate.toLocal()}".split(' ')[0];
                });
              }
            },
          ),
        ),
      ),
    );
  }

  Widget _buildDropdownField(String label, String value, List<String> items, ValueChanged<String?> onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: DropdownButtonFormField<String>(
        value: value,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: Colors.white,
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xFF779A86)),
            borderRadius: BorderRadius.circular(10),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.green),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        onChanged: onChanged,
        items: items.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
      ),
    );
  }
}