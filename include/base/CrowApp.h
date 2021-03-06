#ifndef CROWAPP_H
#define CROWAPP_H

#include "MooseApp.h"

class CrowApp;

template<>
InputParameters validParams<CrowApp>();

class CrowApp : public MooseApp
{
public:
  CrowApp(InputParameters parameters);
  virtual ~CrowApp();

  static void registerApps();
  static void registerObjects(Factory & factory);
  static void associateSyntax(Syntax & syntax, ActionFactory & action_factory);
};

#endif /* CROWAPP_H */
