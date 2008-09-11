/*
 * 
 */
struct hires_unit
{
    char* name;
    float factor;
};
typedef struct hires_unit hires_unit_t;

struct hires_time
{
    hires_value_t  value;
    hires_unit_t   units;
};

typedef struct hires_time hires_time_t;
