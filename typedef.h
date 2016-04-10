typedef enum 
{
  INTEGER,
  DOUBLE,
  COMPLEX
} type_value;

typedef struct
{
  type_value type;
  union
  {
    int ival;
    double dval;
    double complex cval;
  };
} struct_value;
