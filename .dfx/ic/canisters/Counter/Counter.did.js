export const idlFactory = ({ IDL }) => {
  return IDL.Service({
    'add' : IDL.Func([IDL.Float64], [IDL.Float64], []),
    'div' : IDL.Func([IDL.Float64], [IDL.Float64], []),
    'floor' : IDL.Func([], [IDL.Float64], []),
    'mul' : IDL.Func([IDL.Float64], [IDL.Float64], []),
    'power' : IDL.Func([IDL.Float64], [IDL.Float64], []),
    'reset' : IDL.Func([], [IDL.Float64], []),
    'see' : IDL.Func([], [IDL.Float64], ['query']),
    'sqrt' : IDL.Func([], [IDL.Float64], []),
    'sub' : IDL.Func([IDL.Float64], [IDL.Float64], []),
  });
};
export const init = ({ IDL }) => { return []; };
