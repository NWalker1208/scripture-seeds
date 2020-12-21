using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Newtonsoft.Json;

namespace LibraryJSON
{
    class ReferenceConverter : JsonConverter<Reference>
    {
        public override void WriteJson(JsonWriter writer, Reference value, JsonSerializer serializer)
        {
            writer.WriteValue(value.ToString());
        }

        public override Reference ReadJson(JsonReader reader, Type objectType, Reference existingValue, bool hasExistingValue, JsonSerializer serializer)
        {
            if (reader.Value is string str)
                return new Reference(str);
            return null;
        }
    }
}
