#ifndef UIXEVARATE_H
#define UIXEVARATE_H

#include "Kernel.h"

//Forward Declarations
class UIXeVaRate;

template<>
InputParameters validParams<UIXeVaRate>();

class UIXeVaRate : public Kernel
{
public:
  UIXeVaRate(const InputParameters & parameters);

protected:
  virtual Real computeQpResidual();
  virtual Real computeQpJacobian();

private:
  std::string _MXeVa_name;
  const MaterialProperty<Real> & _MXeVa;

  std::string _MUI_name;
  const MaterialProperty<Real> & _MUI;

  const MaterialProperty<Real> & _CU;
  const MaterialProperty<RealGradient> & _grad_CU;

  VariableValue & _c1;
  VariableGradient & _grad_c1;

  VariableValue & _c3;
  VariableGradient & _grad_c3;

  const MaterialProperty<Real> & _kT;
  const MaterialProperty<Real> & _Zg;

  const MaterialProperty<Real> & _dgHXeVaUI;

  std::string _LogC_name;
  const MaterialProperty<Real> & _LogC;

  std::string _LogTol_name;
  const MaterialProperty<Real> & _LogTol;

  const MaterialProperty<Real> & _kappa_cgv;
  const MaterialProperty<Real> & _kappa_cg;
  const MaterialProperty<Real> & _kappa_cui;
  const MaterialProperty<Real> & _kappa_cu;
};

#endif //UIXEVARATE_H
