import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shron/screens/AddPostScreen.dart';
import 'package:shron/screens/ChatScreen.dart';
import 'package:shron/screens/FeedScreen.dart';
import 'package:shron/screens/ProfileScreen.dart';
import 'package:shron/screens/SearchScreen.dart';

const webScreenSize = 600;

List<Widget> homeScreenItems = [
  const FeedScreen(),
  const SearchScreen(),
  const AddPostScreen(),
  const ChatScreen(),
];
