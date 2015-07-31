#ifndef VA2_XEVA2RATE_H
#define VA2_XEVA2RATE_H

#include "Kernel.h"

//Forward Declarations
class Va2_XeVa2Rate;

template<>
InputParameters validParams<Va2_XeVa2Rate>();

class Va2_XeVa2Rate : public Kernel
{
public:
  Va2_XeVa2Rate(const InputParameters & parameters);

protected:
  virtual Real computeQpResidual();
  virtual Real computeQpJacobian();

private:
  std::string _mob_name;
  const MaterialProperty<Real> & _MVa2;

  std::string _mob_name2;
  const MaterialProperty<Real> & _MCgVa;

  std::string _mob_name3;
  const MaterialProperty<Real> & _MVa;

  VariableValue & _c1;
  VariableGradient & _grad_c1;

  VariableValue & _c2;
  VariableGradient & _grad_c2;

  VariableValue & _c3;
  VariableGradient & _grad_c3;

  const MaterialProperty<Real> & _kT;
  const MaterialProperty<Real> & _EBXeVa;
  const MaterialProperty<Real> & _SBXeVa;
  const MaterialProperty<Real> & _EBVaVa;
  const MaterialProperty<Real> & _SBVaVa;
  const MaterialProperty<Real> & _Zg;

  std::string _LogC_name;
  const MaterialProperty<Real> & _LogC;

  std::string _LogTol_name;
  const MaterialProperty<Real> & _LogTol;

  const MaterialProperty<Real> & _kappa_cgv;
  const MaterialProperty<Real> & _kappa_cv;
  const MaterialProperty<Real> & _kappa_cg;
  const MaterialProperty<Real> & _kappa_cvv;
};

#endif //VA2_XEVA2RATE_H
