from setuptools import setup
from sys import platform

setup(name='pydmpc',
      version='0.1.0',
      description='A Python tool for distributed model-based predictive control of energy suppy chains',
      url='https://github.com/RWTH-EBC/pyDMPC',
      author='RWTH Aachen University, E.ON Energy Research Center, '
             'Institute of Energy Efficient Buildings and Indoor Climate',
      author_email='ebc-office@eonerc.rwth-aachen.de',
      packages=[
          'pyDMPC',
          'pyDMPC.ControlFramework',
		  'pyDMPC.ControlFramework.functions'],
      package_data={},
      classifiers=[
          'Operating System :: Microsoft :: Windows',
          'Operating System :: POSIX :: Linux',
          'Programming Language :: Python :: 3.4',
          'Programming Language :: Python :: 3.5',
          'Programming Language :: Python :: 3.6',
          'Intended Audience :: Science/Research',
          'Topic :: Software Development :: Code Generators',
          'Topic :: Scientific/Engineering',
          'Topic :: Utilities'],
      install_requires=['scipy', 'numpy', 'pyads',
      'fmpy', 'modelicares', 'scikit-learn==0.21.3', 'joblib'])
