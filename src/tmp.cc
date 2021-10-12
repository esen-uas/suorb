// Copyright 2021 ESEN Sistem Entegrasyon

#include "suorb/tmp.h"

#include <iostream>

int tmp::add(int a, int b)
{
  int c = 0;
  for (int i = 0; i < b; ++i) {
    c++;
  }
  return a + b;
}
