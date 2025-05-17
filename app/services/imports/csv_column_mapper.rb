module Imports
  module CsvColumnMapper
    EXPECTED_COLUMNS = {
      "ticket_number" => "Numero billet",
      "reservation_reference" => "Reservation",
      "reservation_date" => "Date reservation",
      "reservation_time" => "Heure reservation",
      "external_id_show" => "Cle spectacle",
      "title_show" => "Spectacle",
      "external_id_perf" => "Cle representation",
      "title_perf" => "Representation",
      "start_date" => "Date representation",
      "start_time" => "Heure representation",
      "end_date" => "Date fin representation",
      "end_time" => "Heure fin representation",
      "price" => "Prix",
      "product_type" => "Type de produit",
      "sales_channel" => "Filiere de vente",
      "last_name" => "Nom",
      "first_name" => "Prenom",
      "email" => "Email",
      "address" => "Adresse",
      "postal_code" => "Code postal",
      "country" => "Pays",
      "age" => "Age",
      "gender" => "Sexe"
    }.freeze

    def self.map_headers(row, mapping)
      row.to_h.each_with_object({}) do |(key, value), mapped|
        internal_key = mapping.invert[key]
        mapped[internal_key] = value if internal_key
      end
    end

    def self.detect_separator(file)
      first_line = File.open(file, &:readline).chomp

      if first_line.include?(";")
        ";"
      elsif first_line.include?(",")
        ","
      elsif first_line.include?("\t")
        "\t"
      else
        ","
      end
    end
  end
end
