require "pagy/extras/limit" 
require "pagy/extras/overflow"

Pagy::DEFAULT[:limit] = 30
Pagy::DEFAULT[:limit_max] = 100 
Pagy::DEFAULT[:overflow] = :empty_page 
